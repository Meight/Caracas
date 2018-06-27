import 'dart:async';
import 'dart:convert';

import '../WeatherData.dart';
import 'WeatherProvider.dart';
import 'package:http/http.dart';

class OpenWeatherMapProvider extends WeatherProvider {

  WeatherData _weatherData;

  @override
  Future<WeatherData> fetchWeatherData(double latitude, double longitude) async {
    if(_weatherData != null)
      return _weatherData;

    final response = await get(
        'http://api.openweathermap.org/data/2.5/weather?'
            'lat=$latitude&'
            'lon=$longitude&'
            'APPID=979a578cc99ca5303dba646d4d1528c7&'
            'units=metric');
    final responseJson = json.decode(response.body);
    _weatherData = new WeatherData.fromJson(responseJson);

    return new Future.value(_weatherData);
  }

  @override
  String name() {
    return "Open Weather Map";
  }
}