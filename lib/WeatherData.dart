class WeatherData {
  final double latitude, longitude;
  final String weather, name, country;
  final int temperature;
  final int humidity, cloudiness;
  final double windSpeed;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    print(json);

    return new WeatherData(
        latitude : json['coord']['lat'],
        longitude: json['coord']['lon'],
        weather: json['weather'][0]['main'],
        name: json['name'],
        country: json['sys']['country'],
        temperature: json['main']['temp'],
        humidity: json['main']['humidity'],
        cloudiness: json['clouds']['all'],
        windSpeed: json['wind']['speed']);
  }

  WeatherData({this.latitude, this.longitude, this.weather, this.name, this.country, this.temperature,
      this.humidity, this.cloudiness, this.windSpeed});
}