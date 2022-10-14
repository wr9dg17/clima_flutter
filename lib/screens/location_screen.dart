import 'package:clima_flutter/screens/city_screen.dart';
import 'package:clima_flutter/services/weather.dart';
import 'package:clima_flutter/utils/consts.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  final dynamic data;

  const LocationScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late int temperature;
  late int condition;
  late String cityName;
  final WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(widget.data);
  }

  void updateUI(dynamic data) {
    setState(() {
      double temp = data['main']['temp'];
      temperature = temp.toInt();
      condition = data['weather'][0]['id'];
      cityName = data['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      var data = await weatherModel.getLocationWeather();
                      updateUI(data);
                    },
                    child: const Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var city = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const CityScreen();
                      }));
                      if (city != null) {
                        updateUI(await weatherModel.getCityWeather(city));
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text(
                      '$temperature°',
                      style: kTemperatureTextStyle,
                    ),
                    Text(
                      weatherModel.getWeatherIcon(condition),
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(
                  '${weatherModel.getMessage(temperature)} in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
