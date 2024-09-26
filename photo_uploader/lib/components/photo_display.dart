import 'package:flutter/material.dart';
import 'dart:io';

class PhotoDisplay extends StatelessWidget {
  final String? imagePath;
  final bool isWeb;

  const PhotoDisplay({super.key, required this.imagePath, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return const Center(child: Text('No photo selected.'));
    }

    return isWeb
        ? Image.network(
            imagePath!,
            fit: BoxFit.cover, 
          )
        : Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
          );
  }
}
