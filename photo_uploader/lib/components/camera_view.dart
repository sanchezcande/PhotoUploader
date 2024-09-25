import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatelessWidget {
  final CameraController? cameraController;

  const CameraView({super.key, required this.cameraController}); 

  @override
  Widget build(BuildContext context) {
    return cameraController != null && cameraController!.value.isInitialized
        ? CameraPreview(cameraController!)
        : const Center(child: Text('Camera not initialized.'));
  }
}
