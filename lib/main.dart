import 'package:flutter/material.dart';
import 'package:flutter_face/common.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  XFile? photo;
  FaceDetector? faceDetector;
  var errorCode = '';

  @override
  Widget build(BuildContext context) {
    faceDetector = GoogleMlKit.vision.faceDetector();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              errorCode,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Common.myButton1(
                textLabel: "Pick Image", radius: 30, mCallback: pickImage),
            const SizedBox(
              height: 20,
            ),
            if (photo != null) ...{
              Text(
                'Photo Picked Press Start Detection',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            },
            Text(
              '----------------------------------------',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Common.myButton1(
                textLabel: "Start Detection",
                radius: 30,
                mCallback: startDetect),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void startDetect() async {
    try {
      if (photo != null) {
        errorCode = '';
        final inputImage = InputImage.fromFilePath(photo!.path);
        if (faceDetector != null) {
          final List<Face> faces = await faceDetector!.processImage(inputImage);
          // Handle the detected faces
          for (Face face in faces) {
            // Get the bounding box of the face
            final Rect boundingBox = face.boundingBox;

            // You can also get other properties of the face, such as landmarks
            // Example: final FaceLandmark leftEye = face.landmarks[FaceLandmarkType.leftEye];
          }
        } else {
          errorCode = "Some Error";
        }
      } else {
        errorCode = "Please pick image first";
      }
    } catch (e) {
      errorCode = e.toString();
    }
    setState(() {});
  }
}
