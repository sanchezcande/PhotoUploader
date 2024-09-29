import 'package:riverpod/riverpod.dart';

// Provider para gestionar si la cámara está inicializada
final isCameraInitializedProvider = StateProvider<bool>((ref) => false);

// Provider para gestionar si la foto ha sido tomada
final isPhotoTakenProvider = StateProvider<bool>((ref) => false);

// Provider para almacenar la ruta de la imagen tomada
final imagePathProvider = StateProvider<String?>((ref) => null);
