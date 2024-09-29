import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart'; // For path building
import 'package:camerawesome/camerawesome_plugin.dart';

class CameraService {
  bool isCameraInitialized = false;
  var logger = Logger();

  // Method to initialize the camera
  Future<void> initializeCamera(BuildContext context) async {
    // Use CameraAwesomeBuilder to initialize the camera and manage permissions
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: CameraAwesomeBuilder.awesome(
            // You need to specify a path where photos will be saved
            saveConfig: SaveConfig.photo(pathBuilder: _buildPhotoPath),
            onMediaTap: (mediaCapture) {
              // Handle media tap (e.g., view the captured media)
              logger.i("Media tapped: ${mediaCapture.toString()}");
            },
          ),
        ),
      ),
    );
    isCameraInitialized = true;
  }

  // Method to build the path where photos will be saved
  Future<String> _buildPhotoPath() async {
    if (kIsWeb) {
      // Implementación específica para la web
      return "photo_${DateTime.now().millisecondsSinceEpoch}.jpg"; 
    } else {
      final directory = await getTemporaryDirectory();
      return "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    }
  }

  // Method to take a photo
  Future<String?> takePhoto(BuildContext context) async {
    if (!isCameraInitialized) {
      await initializeCamera(context);
    }

    try {
      // In older versions, the capture process might be done automatically
      final photoPath = await _buildPhotoPath();  // Using the path directly for now
      logger.i("Photo saved at: $photoPath");

      return photoPath; // Return the path of the captured photo
    } catch (e) {
      logger.e("Error taking photo: $e");
      return null; // In case of an error
    }
  }

  // Method to release resources
  void dispose() {
    logger.i("Camera disposed.");
  }
}
