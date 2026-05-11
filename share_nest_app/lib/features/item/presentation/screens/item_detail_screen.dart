import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/owner_info_tile.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: InkWell(
                  onTap: () => context.pop(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new, size: 18),
                      SizedBox(width: 4),
                      Text('Back To Tools'),
                    ],
                  ),
                ),
              ),
              Container(
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 28, 43),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/drill.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Power Drill',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 22, 36, 53),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const OwnerInfoTile(
                      title: 'Owned by',
                      value: 'Tinsae Getaneh',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    const OwnerInfoTile(
                      title: 'Location',
                      value: 'Jemo, Mekanissa',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compact Drill, built for everyday wall drilling and light home projects, this product handles tasks smoothly without strain. It is solid condition, delivering reliable power and steady performance whenever you need it.',
                      style: TextStyle(color: Color.fromARGB(255, 81, 97, 115), height: 1.45),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 233, 248),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Condition & Usage',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('• Includes 2 rechargeable batteries'),
                          Text('• Charger and carrying case included'),
                          Text('• Drill bits available upon request'),
                          Text('• Cleaned and sanitized after each use'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 220, 232, 250),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Text('TOTAL SHARES',
                                    style: TextStyle(fontSize: 10)),
                                Text('14',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 220, 232, 250),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Text('SUCCESS RATE',
                                    style: TextStyle(fontSize: 10)),
                                Text('100%',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 25, 130, 209),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Reserve Now'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 23, 166, 67),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Request to Borrow'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
