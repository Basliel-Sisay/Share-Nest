import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../data/models/resource_item.dart';

class AddResourceScreen extends ConsumerStatefulWidget {
  const AddResourceScreen({super.key, this.editResourceId});

  final String? editResourceId;

  @override
  ConsumerState<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends ConsumerState<AddResourceScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  String? _imagePath;
  bool _isAvailable = true;
  bool _isSaving = false;
  ResourceItem? _editItem;
  bool _isLoadingEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.editResourceId != null) {
      _loadEditResource();
    }
  }

  Future<void> _loadEditResource() async {
    setState(() => _isLoadingEdit = true);
    final repo = ref.read(resourceRepositoryProvider);
    final item = await repo.getResourceById(widget.editResourceId!);
    if (item != null && mounted) {
      _editItem = item;
      _nameController.text = item.title;
      _categoryController.text = item.category;
      _conditionController.text = item.condition;
      _descriptionController.text = item.description;
      _imagePath = item.imagePath.startsWith('assets/') ? null : item.imagePath;
      _isAvailable = item.isAvailable;
    }
    if (mounted) setState(() => _isLoadingEdit = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file != null) {
      setState(() => _imagePath = file.path);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeCategory(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.contains('book')) return 'Books';
    return 'Tools';
  }

  Future<void> _addResource() async {
    final title = _nameController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a resource name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final user = ref.read(authProvider).user;
    final id = _editItem?.id ?? slugifyTitle(title);
    final item = ResourceItem(
      id: id,
      title: title,
      ownerId: _editItem?.ownerId ?? user?.id ?? '',
      ownerName: _editItem?.ownerName ?? user?.name ?? 'You',
      distance: _editItem?.distance ?? 'Nearby',
      rating: _editItem?.rating ?? 5.0,
      category: _normalizeCategory(_categoryController.text),
      description: _descriptionController.text.trim().isEmpty
          ? 'Shared by community member.'
          : _descriptionController.text.trim(),
      imagePath: _imagePath ?? _editItem?.imagePath ?? 'assets/images/drill.png',
      location: _editItem?.location ?? 'Your neighborhood',
      condition: _conditionController.text.trim(),
      isAvailable: _isAvailable,
      statusText: _isAvailable ? 'Available Today' : 'Unavailable',
    );

    try {
      if (_editItem != null) {
        await ref.read(resourcesProvider.notifier).updateResource(item);
      } else {
        await ref.read(resourcesProvider.notifier).addResource(item);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editItem != null
            ? 'Resource updated successfully'
            : 'Resource added successfully'),
        backgroundColor: Colors.green,
      ),
    );
    if (_editItem != null) {
      context.pop();
    } else {
      context.go('/browse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Text(
                  'NEST_ ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.eco, color: Colors.black, size: 26),
              ],
            ),
            Text(
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
      body: _isLoadingEdit
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(isEditing: _editItem != null),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _showImageOptions,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.lightGreen,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_imagePath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_imagePath!),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          const SizedBox(height: 12),
                          const Text(
                            'Upload Item Photos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap to browse gallery or take a photo',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('RESOURCE NAME'),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Power Drill',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('CATEGORY'),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      hintText: 'Tools or Books',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('CONDITION'),
                  TextField(
                    controller: _conditionController,
                    decoration: const InputDecoration(
                      hintText: 'Brand New',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('DESCRIPTION'),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Tell the community about this item, usage tips, or special care instructions...',
                    ),
                  ),
                  const SizedBox(height: 24),
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
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available for Loan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                'Toggle off to temporarily hide this listing',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isAvailable,
                          onChanged: (value) =>
                              setState(() => _isAvailable = value),
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
                      onPressed: _isSaving ? null : _addResource,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isSaving ? 'Saving...' : _editItem != null ? 'Update Resource' : 'Add Resource',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle_outline, size: 20),
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
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({this.isEditing = false});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Edit Resource' : 'Share a Resource',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEditing
                ? "Update your resource details below."
                : "When you share your items, you're helping the whole community grow stronger. Go ahead and list yours below",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
