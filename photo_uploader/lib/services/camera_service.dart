import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; 

class CameraService {
  bool isCameraInitialized = false;
  var logger = Logger();

  Future<void> initializeCamera(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photo(),
          onMediaTap: (mediaCapture) async {
            mediaCapture.captureRequest.when(
              single: (singleCapture) {
                if (singleCapture.file != null) {
                  logger.i("Media captured at: ${singleCapture.file?.path}");
                } else {
                  logger.w("No media captured");
                }
              },
              multiple: (multipleCapture) {
                logger.w("Multiple captures not supported in this implementation");
              },
            );
          },
        ),
      ),
    );
    isCameraInitialized = true;
  }

  // Método para tomar una foto
  Future<String?> takePhoto(BuildContext context) async {
    if (!isCameraInitialized) {
      await initializeCamera(context);
    }
    return null;
  }

  // Método para liberar recursos
  void dispose() {
    // Lógica para liberar recursos si fuera necesario
  }
}
