class WeatherModel {
  final String cityName;
  final double windSpeed;
  final double temperature;
  final int humidity;
  final int sunrise;
  final int sunset;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.sunrise,
    required this.sunset,
    required this.temperature,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      temperature: json['main']['temp'] - 273.15,
    );
  }
}
