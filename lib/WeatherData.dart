class WeatherData {
  final int latitude, longitude;
  final String weather;
  final double temperature, humidity, pressure;
  final double windSpeed;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return new WeatherData(
        latitude : json['lat'],
        longitude: json['lon'],
        weather: json['weather']['main'],
        temperature: json['main']['temp'],
        humidity: json['main']['humidity'],
        pressure: json['main']['pressure'],
        windSpeed: json['wind']['speed']);
  }

  WeatherData({this.latitude, this.longitude, this.weather, this.temperature,
      this.humidity, this.pressure, this.windSpeed});
}