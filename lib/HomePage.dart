import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define requieres instance
  late CameraImage cameraImage;
  late CameraController cameraController;

  // Define requieres variable
  bool isWorking = false;
  String result = " ";

  initCamera() {
    cameraController = CameraController(camera[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if(!isWorking) {
            isWorking = true;
            cameraImage= imageFromStream;
            runModelOnFrame();
          }
        });
      });
    });
  }

  runModelOnFrame() async{
    if(cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true
      );

      result = "";

      recognitions?.forEach((response) {
        result += response["label"] + "\n";
      });

      setState(() {
        //result;
      });

      isWorking = false;
    }
  }

  loadModel() async {
    await Tflite.loadModel(model: "assets/model.tflite",
      labels: "assets/labels.txt");
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: result.isEmpty ? Text('ENFOQUE EL ROSTRO'):
            Padding(padding: EdgeInsets.only(top: 30.0),
              child: Text(result,
              style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          body: Container(
            child: (!cameraController.value.isInitialized)
            ? Container()
            : Align (
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
          ),
          ),
          backgroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
