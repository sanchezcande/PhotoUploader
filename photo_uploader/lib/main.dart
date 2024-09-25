import 'package:flutter/material.dart';
import 'pages/photo_uploader_page.dart';

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
