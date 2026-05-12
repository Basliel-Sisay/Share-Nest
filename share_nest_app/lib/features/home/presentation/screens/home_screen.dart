import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home_item_card.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'NEST_ ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.eco,
                  color: Colors.black,
                  size: 26
                  ),
              ],
            ),
            const Text(
              'ShareNest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'What do you need for your today?',
                style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 45, 55, 66)),
              ),
              const SizedBox(height: 14),
              const HomeSearchBar(),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Near You',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 21, 34, 51),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/browse');
                    },
                    child: const Text('View all →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              HomeItemCard(
                title: 'Power Drill',
                owner: 'Mike R.',
                distance: '0.8 miles',
                status: 'Available Today',
                actionText: 'Request Loan',
                imagePath: 'assets/images/drill.png',
                onTap: () => context.push('/item'),
              ),
              const SizedBox(height: 16),
              HomeItemCard(
                title: 'Python Programming',
                owner: 'Sarah W.',
                distance: '1.2 miles',
                status: 'Free from Mar 15',
                actionText: 'Pre-book',
                imagePath: 'assets/images/python_book.png',
                isActionPrimary: false,
                onTap: () {
                  context.push('/item');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
