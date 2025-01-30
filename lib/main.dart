import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_weather/Models/ApIModel.dart';
import 'package:my_weather/Splash%20Screen.dart';
import 'package:my_weather/weatherpages/Clouds.dart';
import 'package:my_weather/weatherpages/RainyDay.dart';
import 'package:my_weather/weatherpages/Sunnyday.dart';
import 'package:http/http.dart' as http;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


import 'HomeScreenOfPage.dart';
import 'Models/GeoLocationClass.dart';
import 'SearchScreen.dart';

void main() {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

   List<Widget> bottomNaviPages=[HomeMainPage(),Searchscreen()];
  int currentIndexOfBottomNavi=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndexOfBottomNavi,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.white60,
        onTap: (p0) {
          setState(() {
            currentIndexOfBottomNavi=p0;
          });
        },

        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndexOfBottomNavi,
        children: bottomNaviPages,
      )
    );
  }

}
