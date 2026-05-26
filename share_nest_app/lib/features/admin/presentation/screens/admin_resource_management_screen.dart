import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../data/models/resource_item.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../../../core/widgets/resource_image.dart';

class AdminResourceManagementScreen extends ConsumerStatefulWidget {
  const AdminResourceManagementScreen({super.key});

  @override
  ConsumerState<AdminResourceManagementScreen> createState() => _AdminResourceManagementScreenState();
}

class _AdminResourceManagementScreenState extends ConsumerState<AdminResourceManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);
    Widget content;

    content = resourcesAsync.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(16, 185, 129, 1)),
          ),
        );
      },
      error: (e, _) {
        return Center(
          child: Text(
            '$e',
            style: const TextStyle(
              color: Color.fromRGBO(239, 68, 68, 1),
            ),
          ),
        );
      },
      data: (resources) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(resourcesProvider.notifier).refresh();
          },
          color: const Color.fromRGBO(16, 185, 129, 1),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 20,
              right: 20,
            ),
            itemCount: resources.length,
            itemBuilder: (_, i) {
              final r = resources[i];
              
              IconData categoryIcon;
              if (r.category == 'Books') {
                categoryIcon = Icons.book_outlined;
              } else {
                categoryIcon = Icons.build_outlined;
              }

              Color statusColor;
              String statusText;
              if (r.isAvailable) {
                statusColor = const Color.fromRGBO(16, 185, 129, 1);
                statusText = "Available";
              } else {
                statusColor = const Color.fromRGBO(239, 68, 68, 1);
                statusText = "Unavailable";
              }

              return Container(
                margin: const EdgeInsets.only(
                  bottom: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromRGBO(226, 232, 240, 1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(244, 247, 254, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ResourceImage(
                            path: r.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(15, 41, 66, 1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  categoryIcon,
                                  size: 14,
                                  color: const Color.fromRGBO(148, 163, 184, 1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  r.ownerName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(100, 116, 139, 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                left: 8,
                                right: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Color.fromRGBO(59, 130, 246, 1),
                              size: 22,
                            ),
                            onPressed: () {
                              context.push('/edit-resource/${r.id}');
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color.fromRGBO(239, 68, 68, 1),
                              size: 22,
                            ),
                            onPressed: () {
                              _adminDeleteResource(r);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 254, 1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Resource Management',
          style: TextStyle(
            color: Color.fromRGBO(5, 2, 24, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 8,
            right: 8,
          ),
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
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
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
            child: content,
          ),
        ],
      ),
    );
  }

  Future<void> _adminDeleteResource(ResourceItem resource) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Admin: Delete Resource'),
          content: Text('Delete "${resource.title}" as admin?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).deleteResource(resource.id);
      await ref.read(resourcesProvider.notifier).refresh();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource deleted')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }
}
