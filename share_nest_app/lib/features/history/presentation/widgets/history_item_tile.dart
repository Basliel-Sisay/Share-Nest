import 'package:flutter/material.dart';

class HistoryItemTile extends StatelessWidget {
  const HistoryItemTile({
    super.key,
    required this.itemName,
    required this.borrower,
    required this.period,
    required this.stateLabel,
    required this.stateColor,
    this.imagePath,
    this.onApprove,
    this.onReject,
    this.onCancel,
    this.onReturn,
    this.isOwner = false,
  });

  final String itemName;
  final String borrower;
  final String period;
  final String stateLabel;
  final Color stateColor;
  final String? imagePath;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onReturn;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        height: 60,
                        width: 72,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 60,
                        width: 72,
                        color: Colors.grey.shade200,
                        child:
                            const Icon(Icons.inventory_2, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            itemName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 22, 36, 52),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: stateColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            stateLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 20, 51, 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 9,
                          backgroundColor: Color.fromARGB(255, 228, 234, 241),
                          child: Icon(
                            Icons.person,
                            size: 11,
                            color: Color.fromARGB(255, 84, 98, 115),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOwner ? 'Lent to $borrower' : 'Borrowed from $borrower',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 78, 89, 103),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      period,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 91, 103, 116),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onApprove != null ||
              onReject != null ||
              onCancel != null ||
              onReturn != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onCancel != null)
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancel Request',
                        style: TextStyle(color: Colors.red)),
                  ),
                if (onReject != null)
                  TextButton(
                    onPressed: onReject,
                    child: const Text('Reject',
                        style: TextStyle(color: Colors.red)),
                  ),
                if (onApprove != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 121, 64),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onApprove,
                    child: const Text('Approve'),
                  ),
                if (onReturn != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onReturn,
                    child: const Text('Mark as Returned'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
