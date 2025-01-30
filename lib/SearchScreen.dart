import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/ApIModel.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  ApiModel? userApiData;

  Future<void> getLanAndLon(double userLatitude, double userLongitude) async {
    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$userLatitude&lon=$userLongitude&appid=26918183fcdd1894762defc15357b54c&units=metric');

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          userApiData = ApiModel.fromMap(data);
        });
        print("City: ${userApiData?.cityName}");
      } else {
        print("Failed to load weather data: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  final GlobalKey<FormState> GKey = GlobalKey<FormState>();
  final TextEditingController LatitudeController = TextEditingController();
  final TextEditingController LongitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard appears
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(CupertinoIcons.location_solid, color: Colors.white),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Enter Location",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "Poppins_light"),
                    ),
                    backgroundColor: Colors.black,
                    content: SingleChildScrollView( // Allows scrolling
                      child: Form(
                        key: GKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Latitude",
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins_light"),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.teal)),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins_light"),
                              controller: LatitudeController,
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Latitude Can't be Empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10), // Space between fields
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Longitude",
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins_light"),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.teal)),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins_light"),
                              controller: LongitudeController,
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Longitude Can't be Empty";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (GKey.currentState!.validate()) {
                            double? lat =
                            double.tryParse(LatitudeController.text);
                            double? lon =
                            double.tryParse(LongitudeController.text);

                            if (lat != null && lon != null) {
                              getLanAndLon(lat, lon);
                              LongitudeController.clear();
                              LatitudeController.clear();
                              Navigator.of(context).pop();
                            } else {
                              print("Invalid Latitude or Longitude");
                            }
                          }

                        },
                        child: Text("Get Weather",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins_light")),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          LongitudeController.clear();
                          LatitudeController.clear();
                        },
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins_light")),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(CupertinoIcons.add, color: Colors.white),
          ),
        ],
        title: Text("${userApiData?.cityName ?? "City Name"}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins_light")),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Prevents bottom overflow
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Text("${userApiData?.cityName ?? "City Name"}",
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: "Poppins")),
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/weather-app.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text("${userApiData?.temp ?? "Temperature"} °C",
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: "Poppins")),
            ),
            SizedBox(height: 10),
            Center(
              child: Text("${userApiData?.weatherDescription ?? "Weather"}",
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: "Poppins")),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.water_drop_outlined, color: Colors.white),
                Text("Humidity",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Poppins_light")),
                Icon(Icons.compress, color: Colors.white),
                Text("Pressure",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Poppins_light")),
                Icon(CupertinoIcons.wind, color: Colors.white),
                Text("WindSpeed",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Poppins_light")),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${userApiData?.humidity ?? " "} %",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Poppins_light")),
                Text("${userApiData?.pressure ?? " "} hPa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Poppins_light")),
                Text("${userApiData?.windSpeed ?? " "} km/h",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,

                        fontFamily: "Poppins_light")),
              ],
            ),
SizedBox(height: 100,),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  userApiData = null;
                });
              },
              child: Text("Reset Weather",
                  style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
    );
  }
}
