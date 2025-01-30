import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';


class CloudsDay extends StatefulWidget {
  const CloudsDay({super.key});

  @override
  State<CloudsDay> createState() => _CloudsDayState();
}

class _CloudsDayState extends State<CloudsDay> {
  @override
  Widget build(BuildContext context) {
    return const WrapperScene(
      colors: [
        Colors.black
      ],

      children: [
        CloudWidget(),
        WindWidget(),
      ],
    );
  }
}
