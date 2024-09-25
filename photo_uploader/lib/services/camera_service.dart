import 'package:camera/camera.dart';

class CameraService {
  CameraController? _cameraController;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,  
    );
    await _cameraController?.initialize();
  }

  Future<XFile?> takePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return await _cameraController!.takePicture();
    }
    return null;
  }

  CameraController? get cameraController => _cameraController;

  void dispose() {
    _cameraController?.dispose();
  }
}
