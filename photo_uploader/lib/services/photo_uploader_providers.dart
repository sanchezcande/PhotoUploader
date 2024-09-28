import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraInitializedProvider = StateProvider<bool>((ref) => false);

final photoTakenProvider = StateProvider<bool>((ref) => false);

final imagePathProvider = StateProvider<String?>((ref) => null);
