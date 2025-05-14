import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/weatherModel.dart';

class WeatherServices{
  ///////// Note
  // OpenWeather API Setup
  // This app uses OpenWeatherMap for weather data.
  // To run this app:
  //
  // 1. Create a free account at [https://openweathermap.org/api](https://openweathermap.org/api)
  // 2. Get your **API key**
  // 3. Open the file and past here and then run
  final String apiKey = "Your_API_Key";

  Future<WeatherModel> fatchWeatherDetails(String cityName) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');

    final response = await http.get(url);

    if(response.statusCode == 200){
      return WeatherModel.fromJson(json.decode(response.body));
    }else{
      throw Exception("Field to Load weather Data");
    }
  }
}