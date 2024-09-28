import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> uploadImage(String filePath, String fileName) async {
    try {
      File file = File(filePath);
      TaskSnapshot snapshot = await _storage.ref('uploads/$fileName').putFile(file);

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('photos').add({
        'url': downloadUrl,
        'fileName': fileName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _logger.i('Image uploaded successfully');
    } catch (e) {
      _logger.e('Error uploading image: $e');
    }
  }
}