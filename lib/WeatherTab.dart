import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:context_app/WeatherData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocation/geolocation.dart';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(new WeatherTab());

class WeatherTab extends StatefulWidget {
  @override
  WeatherTabState createState() => new WeatherTabState();
}

class WeatherTabState extends State<WeatherTab> {
  WeatherData weatherData = null;

  Future<WeatherData> fetchWeatherData() async {
    LocationResult result = await Geolocation.lastKnownLocation();

    if (weatherData == null && result.isSuccessful) {
      final response = await get(
          'http://api.openweathermap.org/data/2.5/weather?'
              'lat=${result.location.latitude}&'
              'lon=${result.location.longitude}&'
              'APPID=979a578cc99ca5303dba646d4d1528c7&'
              'units=metric');
      final responseJson = json.decode(response.body);

      setState(() {
        weatherData = new WeatherData.fromJson(responseJson);
      });

      return weatherData;
    } else {
      switch (result.error.type) {
        case GeolocationResultErrorType.runtime:
        // runtime error, check result.error.message
          break;
        case GeolocationResultErrorType.locationNotFound:
        // location request did not return any result
          break;
        case GeolocationResultErrorType.serviceDisabled:
        // location services disabled on device
        // might be that GPS is turned off, or parental control (android)
          break;
        case GeolocationResultErrorType.permissionDenied:
        // user denied location permission request
        // rejection is final on iOS, and can be on Android
        // user will need to manually allow the app from the settings
          break;
        case GeolocationResultErrorType.playServicesUnavailable:
        // android only
        // result.error.additionalInfo contains more details on the play services error
          switch(result.error.additionalInfo as GeolocationAndroidPlayServices) {
          // do something, like showing a dialog inviting the user to install/update play services
            case GeolocationAndroidPlayServices.missing:
            case GeolocationAndroidPlayServices.updating:
            case GeolocationAndroidPlayServices.versionUpdateRequired:
            case GeolocationAndroidPlayServices.disabled:
            case GeolocationAndroidPlayServices.invalid:
          }
          break;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    fetchWeatherData();

    Widget titleSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: weatherData != null ? new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    weatherData.name,
                    style: new TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  '${weatherData.country}',
                  style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Icon(
            Icons.pin_drop,
            color: Colors.red[500],
          ),
          new Text(
              '${weatherData.latitude}, ${weatherData.longitude}',
              style: new TextStyle(
                fontSize: 18.0,
                color: Colors.red[500],
              )),
        ],
      ) : null,
    );

    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(
              icon,
              size: 40.0,
              color: color
          ),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    String isItCloudy(int percentage) {
      if (percentage == null)
        return 'Pas d\'infos';
      if (percentage < 30)
        return 'Peu nuageux';
      else if (percentage < 70)
        return 'Nuageux';
      else
        return 'Très nuageux';
    }

    Widget buttonSection = weatherData != null ? new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(FontAwesomeIcons.thermometerHalf, '${weatherData.temperature} °C'),
          buildButtonColumn(FontAwesomeIcons.cloud, '${isItCloudy(weatherData.cloudiness)}'),
          buildButtonColumn(FontAwesomeIcons.tint, '${weatherData.humidity} %'),
        ],
      ),
    ) : null;

    return new MaterialApp(
      title: 'Caracas',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Caracas'),
        ),
        body: new ListView(
          children: [
            titleSection,
            buttonSection
          ],
        ),
      ),
    );
  }

}