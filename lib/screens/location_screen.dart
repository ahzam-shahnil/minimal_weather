import 'dart:ui';
import 'package:Minimal/screens/city_screen.dart';
import 'package:Minimal/services/weather.dart';
import 'package:Minimal/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

WeatherModel weather = WeatherModel();
var _typedName;
String desc;
int condition;
int temp;
var temperature;
String weatherIcon;
String cityName;
WeatherType wtrimg;
int sunrise;
int sunset;
String imgUrl;
String titleCity;
int feelTemp;
var feelTemperature;
int maxTemp;
var maxTemperature;
int minTemp;
var minTemperature;
var cod = 200;

class _LocationScreenState extends State<LocationScreen> {
  void updateUi(dynamic weatherData) {
    var codtemp = weatherData['cod'];

    if (cod == codtemp) {
      setState(() {
        imgUrl = weatherData['weather'][0]['icon'];
        temperature = weatherData['main']['temp'];
        temp = temperature.toInt();
        condition = weatherData['weather'][0]['id'];
        cityName = weatherData['name'];
        desc = weatherData['weather'][0]['description'];

        //sunrise and sunset , we get them in utc format.
        sunrise = weatherData['sys']['sunrise'];
        sunset = weatherData['sys']['sunset'];

        feelTemperature = weatherData['main']['feels_like'];
        feelTemp = feelTemperature.toInt();
        maxTemperature = weatherData['main']['temp_max'];
        maxTemp = maxTemperature.toInt();

        minTemperature = weatherData['main']['temp_min'];
        minTemp = feelTemperature.toInt();
        wtrimg = weather.getWeatherBg(condition, sunset.toString());
      });
    }
  }

  String checkCityName() {
    if (cityName == null) {
      titleCity = '';
    } else {
      titleCity = cityName;
    }
    return titleCity;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            checkCityName(),
          ),
          leading: FlatButton(
            onPressed: () async {
              var weatherData = await weather.getLocation();
              updateUi(
                weatherData,
              );
            },
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                _typedName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityScreen(),
                  ),
                );

                if (_typedName != null) {
                  updateUi(await weather.getCityData(_typedName));
                }
              },
              child: Icon(
                Icons.search_rounded,
                size: 50.0,
              ),
            ),
          ],
        ),
        body: Container(
          child: cityName != null
              ? Stack(
                  children: [
                    WeatherBg(

                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      weatherType: wtrimg,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                child: Container(
                                  child: Text(
                                    '$temp°',
                                    style: kTempTextStyle,
                                  ),
                                ),
                              ),
                              Image.network('$kImgUrl$imgUrl@2x.png'),
                            ],
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.black.withOpacity(0.081),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "${desc.toUpperCase()}",
                                textAlign: TextAlign.left,
                                style: kMessageTextStyle,
                              ),
                            ),
                          ),
                        ),
                        //Details Container
                        SizedBox(
                          height: 30,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: MediaQuery.of(context).size.width / 1.7,
                              color: Colors.black.withOpacity(0.1),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Feels like ",
                                          style: kCreditTextStyle,
                                        ),
                                        TextSpan(
                                          text: " $feelTemp°",
                                          style: kCreditTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Max Temp :",
                                          style: kCreditTextStyle,
                                        ),
                                        TextSpan(
                                          text: " $maxTemp°",
                                          style: kCreditTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Min Temp :",
                                          style: kCreditTextStyle,
                                        ),
                                        TextSpan(
                                          text: " $minTemp°",
                                          style: kCreditTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Sunrise :",
                                              style: kCreditTextStyle,
                                            ),
                                            TextSpan(
                                              text:
                                                  " ${weather.convertTime(sunrise)} ",
                                              style: kCreditTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.wb_sunny,
                                        color: Colors.amber,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Sunset :",
                                              style: kCreditTextStyle,
                                            ),
                                            TextSpan(
                                              text:
                                                  " ${weather.convertTime(sunset)}",
                                              style: kCreditTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.wb_sunny_outlined,
                                        color: Colors.amber,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.bottomCenter,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Developed by",
                                    style: TextStyle(
                                      fontFamily: "Product Sans",
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Ahzam Shahnil ❤",
                                    style: kCreditTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 250,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () async {
                          var weatherData = await weather.getLocation();
                          updateUi(
                            weatherData,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.green,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Get Weather Update",
                              style: kButtonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
