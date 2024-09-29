import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../components/photo_display.dart';
import '../services/camera_service.dart';
import '../services/firebase_service.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/providers.dart';

class PhotoUploaderPage extends StatefulWidget {
  const PhotoUploaderPage({super.key});

  @override
  PhotoUploaderPageState createState() => PhotoUploaderPageState();  
}

class PhotoUploaderPageState extends State<PhotoUploaderPage> {
  final CameraService _cameraService = CameraService();
  final FirebaseService _firebaseService = FirebaseService(); 
  late ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = ProviderContainer();
  }

  Future<void> _openCamera() async {
    await _cameraService.initializeCamera(context); 
    _container.read(isCameraInitializedProvider.notifier).state = true;
  }

  Future<void> _takePhoto() async {
    final imagePath = await _cameraService.takePhoto(context); 
    if (imagePath != null) {
      _container.read(imagePathProvider.notifier).state = imagePath;
      _container.read(isPhotoTakenProvider.notifier).state = true;
    } else {
      _container.read(isPhotoTakenProvider.notifier).state = false;
    }
  }

  Future<void> _uploadPhoto() async {
    final isPhotoTaken = _container.read(isPhotoTakenProvider);
    final imagePath = _container.read(imagePathProvider);

    if (isPhotoTaken && imagePath != null) {
      try {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _firebaseService.uploadImage(imagePath, fileName);
        if (!mounted) return;

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Photo uploaded successfully!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to upload photo: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCameraInitialized = _container.read(isCameraInitializedProvider);
    final isPhotoTaken = _container.read(isPhotoTakenProvider);
    final imagePath = _container.read(imagePathProvider);
    const double aspectRatio = 4 / 3;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Uploader'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: size.height * 0.5,
                    ),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: isPhotoTaken
                          ? PhotoDisplay(
                              imagePath: imagePath,
                              isWeb: kIsWeb,
                            )
                          : isCameraInitialized
                              ? const Center(
                                  child: Text('Camera ready! Please take a photo.'),
                                )
                              : const Center(
                                  child: Text(
                                      'Camera not initialized or photo not taken')),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (!isCameraInitialized)
                  ElevatedButton(
                    onPressed: _openCamera,
                    child: const Text('Open Camera'),
                  ),
                if (isCameraInitialized && !isPhotoTaken)
                  ElevatedButton(
                    onPressed: _takePhoto,
                    child: const Text('Take Photo'),
                  ),
                if (isPhotoTaken)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _container.read(isPhotoTakenProvider.notifier).state = false;
                          _openCamera();
                        },
                        child: const Text('Retake Photo'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _uploadPhoto,
                        child: const Text('Upload Photo'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
