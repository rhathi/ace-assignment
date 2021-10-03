import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FacePage(),
    );
  }
}

class FacePage extends StatefulWidget {
  @override
  createState() => FacePageState();
}

class FacePageState extends State<FacePage> {
  late File _imageFile;
  late List<Face> _faces;
  int faceCount = 0;

  void detectFaces() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final image = InputImage.fromFile(File(imageFile.path));
      final faceDetector = GoogleMlKit.vision.faceDetector();
      final faces = await faceDetector.processImage(image);
      if (mounted) {
        setState(() {
          _imageFile = File(imageFile.path);
          _faces = faces;
          faceCount = faces.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detector'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Total face count:',
          ),
          Text(
            '$faceCount',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: detectFaces,
        tooltip: 'Pick an Image',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
