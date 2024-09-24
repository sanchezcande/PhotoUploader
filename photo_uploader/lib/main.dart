import 'dart:io';  // Para la clase File en dispositivos móviles
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Solo lo usaremos en móvil
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Uploader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PhotoUploaderPage(),
    );
  }
}

class PhotoUploaderPage extends StatefulWidget {
  const PhotoUploaderPage({super.key});

  @override
  PhotoUploaderPageState createState() => PhotoUploaderPageState();
}

class PhotoUploaderPageState extends State<PhotoUploaderPage> {
  File? _image; // Archivo de la imagen seleccionada (para móvil)
  XFile? _webImage; // Para la imagen en web
  final ImagePicker _picker = ImagePicker(); // Usado para móvil

  // Método para seleccionar una imagen de la cámara o galería
  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb) {
      // Si estamos en web, usamos el paquete camera_web
      await _openCameraInWeb();
    } else {
      // Si estamos en móvil, usamos image_picker
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path); // Guardamos la imagen seleccionada en móvil
        } else {
          debugPrint('No image selected.');
        }
      });
    }
  }

CameraController? _cameraController; // Definimos un controlador global

Future<void> _openCameraInWeb() async {
  try {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      debugPrint('No cameras found.');
      return;
    }

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );

    await _cameraController?.initialize();

    if (!_cameraController!.value.isInitialized) {
      debugPrint('Camera initialization failed.');
      return;
    }

    setState(() {}); 

    debugPrint('Camera initialized.');

  } catch (e) {
    debugPrint('Error initializing camera: $e');
  }
}

@override
void dispose() {
  _cameraController?.dispose();
  super.dispose();
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Photo Uploader'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (kIsWeb && _cameraController != null && _cameraController!.value.isInitialized) 
            Expanded(  
              child: CameraPreview(_cameraController!), 
            )
          else if (_webImage != null)
            Image.network(_webImage!.path) 
          else if (!kIsWeb && _image != null)
            Image.file(_image!) 
          else
            const Text('No image selected or camera feed.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: const Text('Take a Photo'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery), 
            child: const Text('Pick from Gallery'),
          ),
        ],
      ),
    ),
  );
}
}