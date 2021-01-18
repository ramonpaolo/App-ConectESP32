import 'package:automatization/src/home.dart';
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

void main() {
  runApp(MaterialApp(
    home: Splash(),
    title: "Automatização",
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      splashscreenWidget: SplashScreen(),
      timerInSeconds: 1,
      gotoWidget: Home(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
