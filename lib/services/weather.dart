import 'package:Minimal/services/location.dart';
import 'package:Minimal/services/networking.dart';
import 'package:Minimal/utilities/constants.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class WeatherModel {
  Future<dynamic> getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$kOpenWeatherUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$kOpenWeatherApiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCityData(String typedName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$kOpenWeatherUrl?q=$typedName&appid=$kOpenWeatherApiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  WeatherType _weatherinfo;

  bool checkSunset(String timeNum) {
    timeNum = timeNum + '180';

    int testt = int.parse(timeNum);
    DateTime temp = DateTime.now();

    DateTime time = DateTime.fromMillisecondsSinceEpoch(testt);
    if (time.hour <= temp.hour) {
      if (time.minute <= temp.minute) {
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  String convertTime(int timeNum) {
    String tempor = timeNum.toString() + '180';
    int temp = int.parse(tempor);
    DateTime uctTime = DateTime.fromMillisecondsSinceEpoch(temp);
    String localTime = '${uctTime.hour}:${uctTime.minute}';

    if (uctTime.hour > 12) {
      
       if (uctTime.minute < 10) {
        localTime = '${uctTime.hour % 12}: 0${uctTime.minute} pm';
      } else {
        localTime = '${uctTime.hour % 12}:${uctTime.minute} pm';
      }
    } else {
      if (uctTime.minute < 10) {
        localTime = '${uctTime.hour}: 0${uctTime.minute} am';
      } else {
        localTime = '${uctTime.hour}:${uctTime.minute} am';
      }
    }
    return localTime;
  }

  WeatherType getWeatherBg(int condition, String sunset) {
    if (condition <= 232 && condition >= 200) {
      _weatherinfo = WeatherType.thunder;
    } else if (condition <= 321 && condition >= 300) {
      _weatherinfo = WeatherType.middleRainy;
    } else if (condition <= 531 && condition >= 500) {
      _weatherinfo = WeatherType.heavyRainy;
    } else if (condition <= 622 && condition >= 600) {
      _weatherinfo = WeatherType.heavySnow;
    } else if (condition < 800 && condition >= 701) {
      if (condition == 721) {
        _weatherinfo = WeatherType.hazy;
      } else if (condition == 761) {
        _weatherinfo = WeatherType.dusty;
      } else if (condition == 741) {
        _weatherinfo = WeatherType.foggy;
      }
    } else if (condition == 800) {
      if (!checkSunset(sunset)) {
        _weatherinfo = WeatherType.sunny;
      } else {
        _weatherinfo = WeatherType.sunnyNight;
      }
    } else if (condition >= 801 && condition <= 804) {
      if (!checkSunset(sunset))
        _weatherinfo = WeatherType.cloudy;
      else {
        _weatherinfo = WeatherType.cloudyNight;
      }
    } else {
      _weatherinfo = WeatherType.dusty;
    }
    return _weatherinfo;
  }
}
