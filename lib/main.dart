import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_weather/Models/ApIModel.dart';
import 'package:my_weather/Splash%20Screen.dart';
import 'package:my_weather/weatherpages/Clouds.dart';
import 'package:my_weather/weatherpages/RainyDay.dart';
import 'package:my_weather/weatherpages/Sunnyday.dart';
import 'package:http/http.dart' as http;

import 'Models/GeoLocationClass.dart';

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
  var pages = [const SunnyDay(), const Rainyday(), const CloudsDay()];
  var AllApiData=[];


  int? pagecount;
  bool isLoadingData = false;

  bool isMainLoading = false;
  double? langitude;
  double? longitude;

  Future getLanAndLon() async {
    setState(() {
      isLoadingData = true;
    });
    try {
      var position = await GetLocation.GetCurrentCordinartes();
      setState(() {
        langitude = position.latitude;
        longitude = position.longitude;
      });
      await getApidetails();
      print("longitude $longitude");
      print("laditude $langitude");
    } catch (e) {
      print(e);
    } finally {}
  }

  ApiModel? Apidata;
  Future getApidetails() async {
    try {
      if (longitude == null || langitude == null) return;

      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${langitude!}&lon=${longitude!}&appid=26918183fcdd1894762defc15357b54c&units=metric'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          Apidata = ApiModel.fromMap(data);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      if (Apidata?.weatherMain == "Clouds" ||
          Apidata?.weatherMain == "clouds" ||
          Apidata?.weatherMain == "CLOUDS") {
        pagecount = 2;
      } else if (Apidata?.weatherMain == "Rain" ||
          Apidata?.weatherMain == "rain" ||
          Apidata?.weatherMain == "RAIN") {
        pagecount = 1;
      } else {
        pagecount = 0;
      }
      isLoadingData = false;
       AllApiData=["Langitude : $langitude","Longitude : $longitude","Temperature : ${Apidata?.temp}°C","Humidity : ${Apidata?.humidity}","Pressure : ${Apidata?.pressure}","WindSpeed : ${Apidata?.windSpeed}","Weather Description : ${Apidata?.weatherDescription}"];
    }
  }

  @override
  void initState() {
    super.initState();
    getLanAndLon();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              );
            },
          )),
      drawer: Drawer(
        backgroundColor: Colors.black,
        elevation: 11,
        shadowColor: Colors.white10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Center(
                child: Container(
                  child: Text("${Apidata?.cityName}",style: TextStyle(color: Colors.teal,fontFamily: "Poppins_light",fontSize: 30),),
                  ),
              ),
            ),
            const SizedBox(height: 20),

            // Show a message if data is not available
            AllApiData.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${AllApiData[index]}",
                      style: TextStyle(color: Colors.white,fontFamily: "Poppins_light"),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(color: Colors.white),
                itemCount: AllApiData.length,
              ),
            ),
          ],
        ),
      ),

      backgroundColor: Colors.black,
      body: Center(
        child: isLoadingData
            ? CupertinoActivityIndicator()
            : Column(
                children: [
                  Container(
                    height: 470,
                    width: double.infinity,
                    child: pages[pagecount ?? 0],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 250,
                    width: 375,
                    child: Card(
                      elevation: 15,
                      shadowColor: Colors.white10,
                      color: Colors.white10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Apidata?.temp}°C",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 55,
                              ),
                              Text(
                                "${Apidata?.weatherMain}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Apidata?.cityName}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: "Poppins_light",
                                    fontWeight: FontWeight.w200),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
