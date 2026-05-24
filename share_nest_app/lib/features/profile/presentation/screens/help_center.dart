import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ExpansionTile(
              title: const Text('How do I borrow an item'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('To borrow an item, first go to the Resources screen to browse our available collection. Click on the item you are interested in to view its full details. Once you are ready to proceed, click the Borrow button and follow the prompts to complete your request.'),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('How do I return an item'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Go to your Sharing History, find the active loan, and click the Return button.'),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Contact Support'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('If you have any further questions or need assistance, the best way to contact our support team is by calling us at +251 9 11 12 13 14 or +251 9 98 97 96 95.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
