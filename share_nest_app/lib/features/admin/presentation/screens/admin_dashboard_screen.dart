import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiClientProvider);
      final stats = await api.getOne('/api/admin/stats');
      setState(() => _stats = stats);
    } catch (_) {

    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 254, 1),
      // I changed this to true so that the gradient background can slide right under the status bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Admin Control Panel',
          style: TextStyle(
            color: Color.fromRGBO(5, 2, 24, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        // I also replaced the basic arrow back with this white circular button layout to match our main app screen headers
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromRGBO(15, 41, 66, 1),
              size: 16,
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // This is a new gradient layer I added at the top and it blends from our mobile app branding's light green down into the light background gray
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(90, 255, 98, 1),
                    Color.fromRGBO(244, 247, 250, 0.1),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadStats,
              color: const Color.fromRGBO(16, 185, 129, 1),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left:20,
                  right:20,
                  top:12,
                  bottom:12,
                  ),
                children: [
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 60,
                          bottom: 60,
                          ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(16, 185, 129, 1)),
                        ),
                      ),
                    )
                  else if (_stats != null) ...[
                    _StatGrid(stats: _stats!),
                  ],
                  const SizedBox(height: 36),
                  // I added a little vertical green indicator line next to the section title here to make it look more professional and visually separate it from the stats section from the above
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(16, 185, 129, 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),

                      const Text(
                        'SYSTEM MANAGEMENT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 116, 139, 1),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    icon: Icons.people_outline,
                    title: 'Users and Neighbors',
                    subtitle: 'View, authorize and manage registered users',
                    onTap: () => context.push('/admin/users'),
                  ),
                  _MenuCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Shared Resources',
                    subtitle: 'Audit listing compliance and item galleries',
                    onTap: () => context.push('/admin/resources'),
                  ),
                  _MenuCard(
                    icon: Icons.handshake_outlined,
                    title: 'Active Loans',
                    subtitle: 'Track exchange dates and dispute tickets',
                    onTap: () => context.push('/admin/loans'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    int totalUsers;
    if(stats['totalUsers'] != null){
        totalUsers = stats['totalUsers'];
      } 
      else{
        totalUsers = 0;
      }
      int totalResources;
      if(stats['totalResources'] != null){
        totalResources = stats['totalResources'];
      } 
      else{
        totalResources = 0;
      }
      int totalLoans;
      if(stats['totalLoans'] != null){
        totalLoans = stats['totalLoans'];
      } 
      else{
        totalLoans = 0;
      }
      int pendingLoans;
      if(stats['pendingLoans'] != null){
        pendingLoans = stats['pendingLoans'];
      } 
      else{
        pendingLoans = 0;
      }
    final items = [
      _StatItem(
        'Total Users',
        totalUsers, 
        Icons.people_alt_outlined, 
        const Color.fromRGBO(16, 185, 129, 1)
      ),
      _StatItem(
        'Resources', 
        totalResources, 
        Icons.category_outlined, 
        const Color.fromRGBO(52, 211, 153, 1)
      ),
      _StatItem(
        'Completed Loans', 
        totalLoans, Icons.assignment_turned_in_outlined, 
        const Color.fromRGBO(5, 150, 105, 1)
      ),
      _StatItem(
        'Pending Actions', 
        pendingLoans, Icons.hourglass_empty_rounded, 
        const Color.fromRGBO(239, 68, 68, 1)
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.25,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final label = item.label;
        final value = item.value;
        final icon = item.icon;
        final color = item.color;

        // I upgraded this card container with a slate border and a softer drop shadow so it looks like it sits nicely on the screen surface
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromRGBO(226, 232, 240, 1), 
              width: 1
              ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Made the dynamic stat text values bolder and slightly tighter so they pop out immediately
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(15, 41, 66, 1),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(148, 163, 184, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem{
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  _StatItem(
    this.label, 
    this.value, 
    this.icon, 
    this.color
    );
}

class _MenuCard extends StatelessWidget{
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Replaced the flat default list tile card with this customized rounded card and also it matches the stat grid borders 
    return Container(
      margin: const EdgeInsets.only(bottom:14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(226, 232, 240, 1), 
          width: 1
          ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.only(
              left:16,
              right:16,
              top:18,
              bottom:18
              ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 253, 244, 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon, 
                    color: const Color.fromRGBO(16, 185, 129, 1), 
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(15, 41, 66, 1),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(100, 116, 139, 1),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // I also replaced the chevron icon 
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromRGBO(184, 199, 215, 1),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}