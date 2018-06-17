import 'dart:async';

import 'package:context_app/WeatherData.dart';

abstract class WeatherProvider {
  Future<WeatherData> fetchWeatherData(double latitude, double longitude);
}