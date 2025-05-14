import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/weatherModel.dart';
import '../Services/weatherServices.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  WeatherModel? _weatherModel;
  bool isLoading = false;
  final TextEditingController _cityNameController = TextEditingController();

  void getWeatherDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final weather = await _weatherServices.fatchWeatherDetails(
        _cityNameController.text,
      );
      setState(() {
        _weatherModel = weather;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error Fetching Weather Data")));
      setState(() {
        isLoading = false;
      });
    }
  }

  LinearGradient getWeatherGradient(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('rain') || desc.contains('light')) {
      return LinearGradient(
        colors: [Colors.indigo, Colors.blue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('clear') || desc.contains('sunny')) {
      return LinearGradient(
        colors: [Colors.orangeAccent.shade200, Colors.deepOrange.shade200],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('cloudy') || desc.contains('overcast')) {
      return LinearGradient(
        colors: [Colors.grey.shade900, Colors.blueGrey, Colors.grey.shade400],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return LinearGradient(
        colors: [
          Color.fromARGB(200, 58, 123, 213),
          Color.fromARGB(170, 142, 84, 233),
          Color.fromARGB(150, 255, 175, 189),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient:
            _weatherModel != null
                ? getWeatherGradient(_weatherModel!.description)
                : LinearGradient(
              colors: [Colors.grey, Colors.black12],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Weather",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    controller: _cityNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      // semi-transparent white
                      hintText: 'Enter city name',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: getWeatherDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      shadowColor: Colors.blue,
                      minimumSize: Size(100, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Click",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),

                  if (_weatherModel != null)
                    screenCard(weatherModel: _weatherModel!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class screenCard extends StatelessWidget {
  final WeatherModel weatherModel;

  const screenCard({super.key, required this.weatherModel});

  String formatTime(int timeStemp) {
    final date =
    DateTime.fromMillisecondsSinceEpoch(timeStemp * 1000).toLocal();
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 21, 32, 43),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    weatherModel.description.toLowerCase().contains("rain")
                        ? "assets/gift/rain.gif"
                        : weatherModel.description.toLowerCase().contains(
                      "light",
                    )
                        ? "assets/gift/rain.gif"
                        : weatherModel.description.toLowerCase().contains(
                      "clear",
                    )
                        ? "assets/gift/clear.gif"
                        : weatherModel.description.toLowerCase().contains("sky")
                        ? "assets/gift/clear.gif"
                        : weatherModel.description.toLowerCase().contains(
                      "overcast clouds",
                    )
                        ? "assets/gift/cloudy.gif"
                        : "assets/gift/sunny.gif",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weatherModel.cityName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "- ${weatherModel.temperature.toStringAsFixed(1)} °C",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Humidity",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${weatherModel.humidity} %",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Wind Speed",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${weatherModel.windSpeed} m/s",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.wb_sunny_outlined, color: Colors.white),
                      Text(
                        "Sun rise",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatTime(weatherModel.sunrise),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Icon(Icons.nights_stay_outlined, color: Colors.white),
                      Text(
                        "Sun set",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatTime(weatherModel.sunset),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
