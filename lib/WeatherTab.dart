import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'providers/WeatherContainer.dart';
import 'WeatherData.dart';
import 'providers/OpenWeatherMapProvider.dart';
import 'providers/WeatherProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocation/geolocation.dart';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AppBootstrapper.dart';
import 'package:dioc/dioc.dart' as dioc;

void main() => runApp(new WeatherTab());

class WeatherTab extends StatefulWidget {
  @override
  WeatherTabState createState() => new WeatherTabState();
}

class WeatherTabState extends State<WeatherTab> {
  WeatherData weatherData = null;
  String _error;
  var _weatherProvider;
  final dioc.Container container = AppBootsrapperBuilder.build().production();

  Future<WeatherData> fetchWeatherData() async {
    LocationResult result = await Geolocation.lastKnownLocation();

    if (result.isSuccessful) {
      setState(() {
        _weatherProvider
            .fetchWeatherData(result.location.latitude, result.location.longitude)
            .then((onValue) => weatherData = onValue);
        _error = null;
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
          _error = "Le GPS n'est pas activé.";
          break;
        case GeolocationResultErrorType.permissionDenied:
          _error = "Permission nécessaire pour la localisation.";
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
    // Inject dependencies.
    _weatherProvider = container.singleton(WeatherProvider);

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

    Widget errorSection = _error != null ? new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Text(
        _error,
        style: new TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: Colors.red[500],
        ),
      ),
    ) : null;

    Widget apiInfo = new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Row(
            children: [
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: new Text(
                        'API utilisée',
                        style: new TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    new Text(
                      _weatherProvider.name(),
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            ]
        )
    );

    Widget loadingIndicator = weatherData == null ? new Container(
      color: Colors.blue,
      width: 80.0,
      height: 80.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();

    return new MaterialApp(
      title: 'Caracas',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Caracas - 8INF956'),
        ),
        body: new ListView(
          children: [
            titleSection,
            buttonSection,
            loadingIndicator,
            apiInfo
          ],
        ),
      ),
    );
  }

}