import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_weather/main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),() => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
      return HomeScreen();
    },)),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Weather At You",
          style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: "Poppins_light"),
        ),
      ),
    );
  }
}
