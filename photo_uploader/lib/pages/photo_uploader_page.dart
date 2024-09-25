import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/camera_view.dart';
import '../components/photo_display.dart';
import '../services/camera_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PhotoUploaderPage extends StatefulWidget {
  const PhotoUploaderPage({super.key}); 

  @override
  PhotoUploaderPageState createState() => PhotoUploaderPageState(); 
}

class PhotoUploaderPageState extends State<PhotoUploaderPage> {
  final CameraService _cameraService = CameraService(); 
  XFile? _webImage;
  File? _image;
  bool _isPhotoTaken = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openCamera() async {
    await _cameraService.initializeCamera();
    setState(() {});
  }

  Future<void> _takePhoto() async {
    if (kIsWeb) {
      final image = await _cameraService.takePhoto();
      setState(() {
        _webImage = image;
        _isPhotoTaken = true;
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _isPhotoTaken = true;
        }
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_isPhotoTaken) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
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
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox( 
              width: mediaQuery.size.width * 0.7,
              height: mediaQuery.size.height * 0.5,
              child: _isPhotoTaken
                  ? PhotoDisplay(
                      imagePath: kIsWeb ? _webImage?.path : _image?.path,
                      isWeb: kIsWeb,
                    )
                  : CameraView(cameraController: _cameraService.cameraController),
            ),
            const SizedBox(height: 20),
            if (!_isPhotoTaken)
              ElevatedButton(
                onPressed: _openCamera,
                child: const Text('Open Camera'),
              ),
            if (_isPhotoTaken)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPhotoTaken = false;
                      });
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
            if (!_isPhotoTaken)
              ElevatedButton(
                onPressed: _takePhoto,
                child: const Text('Take Photo'),
              ),
          ],
        ),
      ),
    );
  }
}
