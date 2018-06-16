class WeatherData {
  final double latitude, longitude;
  final String weather;
  final double temperature;
  final int humidity, pressure;
  final double windSpeed;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    print(json);
    return new WeatherData(
        latitude : json['coord']['lat'],
        longitude: json['coord']['lon'],
        weather: json['weather'][0]['main'],
        temperature: json['main']['temp'],
        humidity: json['main']['humidity'],
        pressure: json['main']['pressure'],
        windSpeed: json['wind']['speed']);
  }

  WeatherData({this.latitude, this.longitude, this.weather, this.temperature,
      this.humidity, this.pressure, this.windSpeed});
}