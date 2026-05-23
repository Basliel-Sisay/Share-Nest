import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class AddResourceScreen extends StatelessWidget {
  const AddResourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareNest'),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.eco),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share a Resource',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "When you share your items, you're helping the whole community grow stronger. Go ahead and list yours below",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lightGreen, width: 1, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Upload Item Photos',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap to browse gallery or take a photo',
                          style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Form Fields
                  _buildLabel('RESOURCE NAME'),
                  _buildTextField(hint: 'e.g., Power Drill'),
                  
                  const SizedBox(height: 16),
                  _buildLabel('CATEGORY'),
                  _buildTextField(hint: 'Tools & Equipment'),
                  
                  const SizedBox(height: 16),
                  _buildLabel('CONDITION'),
                  _buildTextField(hint: 'Brand New'),
                  
                  const SizedBox(height: 16),
                  _buildLabel('DESCRIPTION'),
                  _buildTextField(
                    hint: 'Tell the community about this item, usage tips, or special care instructions...',
                    maxLines: 4,
                  ),
                  
                  const SizedBox(height: 24),
                  // Available for Loan Toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.calendar_month_outlined, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available for Loan',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              Text(
                                'Toggle off to temporarily hide this listing',
                                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: true,
                          onChanged: (val) {},
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.primaryGreen,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add Resource', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle_outline, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }
}
