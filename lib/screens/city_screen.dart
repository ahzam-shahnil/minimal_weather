import 'package:Minimal/services/weather.dart';
import 'package:Minimal/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final myController = TextEditingController();
  String typedValue;
  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    typedValue = myController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15,top: 10),
              child: TextField(
                autofocus: kTxtFocus,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.green,
                keyboardType: TextInputType.text,
                controller: myController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter a search term',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                autofillHints: [AutofillHints.addressCity],
                enableSuggestions: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (typedValue.isNotEmpty) {
                  checkCityWeather(typedValue);
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 3.7 / 1.5,
                    child: Container(
                     
                      alignment: Alignment.center,
                      color: Colors.greenAccent.withOpacity(0.5),
                      child: Icon(
                        Icons.search,
                        size: 70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkCityWeather(String typedData) async {
    WeatherModel wm = WeatherModel();
    var weatherTemp = await wm.getCityData(typedData);
    var codtemp = weatherTemp['cod'];
    
    if (codtemp == 200) {
      Navigator.pop(context, typedData);
    } else {
      _onAlertButtonsPressed(context);
    }
  }

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Weather Search",
      desc: "Weather not found for Current City.",
      buttons: [
        DialogButton(
          child: Text(
            "Exit",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => SystemNavigator.pop(),
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ],
    ).show();
  }
}
