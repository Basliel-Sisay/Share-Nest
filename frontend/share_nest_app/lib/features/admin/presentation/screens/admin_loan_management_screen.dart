import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../../../core/widgets/resource_image.dart';

class AdminLoanManagementScreen extends ConsumerStatefulWidget {
  const AdminLoanManagementScreen({super.key});

  @override
  ConsumerState<AdminLoanManagementScreen> createState() => _AdminLoanManagementScreenState();
}

class _AdminLoanManagementScreenState extends ConsumerState<AdminLoanManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansProvider);
    Widget content;

    content = loansAsync.when(
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
      data: (loans) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(loansProvider.notifier).refresh();
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
            itemCount: loans.length,
            itemBuilder: (_, i) {
              final loan = loans[i];

              Color statusColor;
              if (loan.statusText == 'ACTIVE') {
                statusColor = const Color.fromRGBO(16, 185, 129, 1);
              } else if (loan.statusText == 'PENDING') {
                statusColor = const Color.fromRGBO(245, 158, 11, 1);
              } else if (loan.statusText == 'RETURNED') {
                statusColor = const Color.fromRGBO(59, 130, 246, 1);
              } else {
                statusColor = const Color.fromRGBO(148, 163, 184, 1);
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(244, 247, 254, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ResourceImage(
                                path: loan.imagePath,
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
                                  loan.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(15, 41, 66, 1),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.swap_horiz,
                                      size: 14,
                                      color: Color.fromRGBO(148, 163, 184, 1),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${loan.borrowerName} from ${loan.ownerName}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(100, 116, 139, 1),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              loan.statusText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        height: 1,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: Color.fromRGBO(148, 163, 184, 1),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                loan.dateText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(100, 116, 139, 1),
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            onSelected: (status) {
                              _adminUpdateLoanStatus(loan.id, status);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 6,
                                bottom: 6,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(244, 247, 254, 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Actions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(15, 41, 66, 1),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Color.fromRGBO(15, 41, 66, 1),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (_) {
                              List<PopupMenuEntry<String>> items = [];
                              if (loan.isPending) {
                                items.add(
                                  const PopupMenuItem(
                                    value: 'CONFIRMED',
                                    child: Text('Confirm'),
                                  ),
                                );
                                items.add(
                                  const PopupMenuItem(
                                    value: 'REJECTED',
                                    child: Text('Reject'),
                                  ),
                                );
                              }
                              
                              bool canCancel = false;
                              if (loan.isPending) {
                                canCancel = true;
                              } else if (loan.isApproved) {
                                canCancel = true;
                              } else if (loan.isActive) {
                                canCancel = true;
                              }

                              if (canCancel) {
                                items.add(
                                  const PopupMenuItem(
                                    value: 'CANCELLED',
                                    child: Text('Cancel'),
                                  ),
                                );
                              }

                              if (loan.isActive) {
                                items.add(
                                  const PopupMenuItem(
                                    value: 'RETURNED',
                                    child: Text('Mark Returned'),
                                  ),
                                );
                              }
                              return items;
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
          'Loan Management',
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

  Future<void> _adminUpdateLoanStatus(String loanId, String status) async {
    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).updateLoanStatus(loanId, status);
      await ref.read(loansProvider.notifier).updateLoanStatus(loanId, status);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loan $status')),
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
