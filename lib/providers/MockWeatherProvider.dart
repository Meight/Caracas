import 'dart:async';
import 'dart:convert';

import '../WeatherData.dart';
import 'WeatherProvider.dart';
import 'package:http/http.dart';

class MockWeatherProvider extends WeatherProvider {

  WeatherData _weatherData;

  @override
  Future<WeatherData> fetchWeatherData(double latitude, double longitude) async {
    _weatherData = new WeatherData(
        latitude : 10.0,
        longitude: 10.0,
        weather: "Cool",
        name: "Paris",
        country: "France",
        temperature: 30,
        humidity: 30,
        cloudiness: 15,
        windSpeed: 4.0);

    return new Future.value(_weatherData);
  }

  @override
  String name() {
    return "Mock Weather Provider";
  }
}