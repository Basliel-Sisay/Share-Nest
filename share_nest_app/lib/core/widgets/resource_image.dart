import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ResourceImage extends StatelessWidget {
  const ResourceImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;

  bool get _isAsset => path.startsWith('assets/');
  bool get _isFile =>
      !kIsWeb && (path.startsWith('/') || RegExp(r'^[A-Za-z]:\\').hasMatch(path));

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        path,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (_isFile) {
      return Image.file(
        File(path),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return Image.network(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
    );
  }
}
