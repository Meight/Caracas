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

void main() => runApp(new WeatherTab());

class WeatherTab extends StatefulWidget {
  @override
  WeatherTabState createState() => new WeatherTabState();
}

class WeatherTabState extends State<WeatherTab> {
  Future<WeatherData> fetchWeatherData() async {
    LocationResult result = await Geolocation.lastKnownLocation();

    if (result.isSuccessful) {
      final response = await get(
          'http://api.openweathermap.org/data/2.5/weather?'
              'lat=${result.location.latitude}&'
              'lon=${result.location.longitude}&'
              'APPID=979a578cc99ca5303dba646d4d1528c7');
      final responseJson = json.decode(response.body);

      return new WeatherData.fromJson(responseJson);
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
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Caracas'),
        ),
        body: new Center(
          child: new FutureBuilder<WeatherData>(
            future: fetchWeatherData(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                return new Text(snapshot.data.weather);
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

}