import 'dart:async';

import '../WeatherData.dart';

abstract class WeatherProvider {
  String name();
  Future<WeatherData> fetchWeatherData(double latitude, double longitude);
}