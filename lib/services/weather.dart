import 'package:clima_flutter/services/location.dart';
import 'package:clima_flutter/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherModel {
  Future<dynamic> getCityWeather(String city) async {
    NetworkHelper networkHelper = NetworkHelper(
      Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'q': city,
        'appid': dotenv.env['WEATHER_API_KEY'],
        'units': 'metric'
      })
    );

    return await networkHelper.getData();
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        Uri.https('api.openweathermap.org', '/data/2.5/weather', {
          'lat': '${location.latitude}',
          'lon': '${location.longitude}',
          'appid': dotenv.env['WEATHER_API_KEY'],
          'units': 'metric'
        })
    );

    return await networkHelper.getData();
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '๐ฉ';
    } else if (condition < 400) {
      return '๐ง';
    } else if (condition < 600) {
      return 'โ๏ธ';
    } else if (condition < 700) {
      return 'โ๏ธ';
    } else if (condition < 800) {
      return '๐ซ';
    } else if (condition == 800) {
      return 'โ๏ธ';
    } else if (condition <= 804) {
      return 'โ๏ธ';
    } else {
      return '๐คทโ';
    }
  }

  String getMessage(int temperature) {
    if (temperature > 25) {
      return 'It\'s ๐ฆ time';
    } else if (temperature > 20) {
      return 'Time for shorts and ๐';
    } else if (temperature < 10) {
      return 'You\'ll need ๐งฃ and ๐งค';
    } else {
      return 'Bring a ๐งฅ just in case';
    }
  }
}