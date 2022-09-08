import 'package:flutter/material.dart';
import 'package:mask_detector_app/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new HomePage(),
      title: Text("Detector de Mascarillas",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26, color: Colors.black
        ),
      ),
      image: Image.asset("assets/man_mask.png"),
      photoSize: 150,
      backgroundColor: Colors.white,
      loaderColor: Colors.blueAccent,
      loadingText: Text("by Franklin Enriquez \n & Jackson Quintanilla",
        style: TextStyle(
            color: Colors.black,
            fontSize: 16.0
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
