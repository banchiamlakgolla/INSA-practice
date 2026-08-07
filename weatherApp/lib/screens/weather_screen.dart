import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();

  Weather? weather;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      final data = await weatherService.getWeather();

      setState(() {
        weather = Weather.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Could not load weather data';
        isLoading = false;
      });
    }
  }

  String getWeatherCondition(int code) {
    if (code == 0) {
      return 'Clear sky';
    } else if (code >= 1 && code <= 3) {
      return 'Partly cloudy';
    } else if (code >= 51 && code <= 67) {
      return 'Rain';
    } else if (code >= 71 && code <= 77) {
      return 'Snow';
    } else if (code >= 80 && code <= 82) {
      return 'Rain showers';
    } else if (code >= 95) {
      return 'Thunderstorm';
    }

    return 'Cloudy';
  }

  IconData getWeatherIcon(int code) {
    if (code == 0) {
      return Icons.wb_sunny;
    } else if (code >= 1 && code <= 3) {
      return Icons.cloud;
    } else if (code >= 51 && code <= 82) {
      return Icons.water_drop;
    } else if (code >= 95) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu, size: 30),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month, size: 28),
                  ),
                ],
              ),
            ),

            // Location
            const Text(
              'Addis Ababa, Ethiopia',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            // Weather icon
            Icon(
              getWeatherIcon(weather!.weatherCode),
              size: 120,
              color: Colors.lightBlueAccent,
            ),

            const SizedBox(height: 20),

            // Temperature
            Text(
              '${weather!.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 58, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Weather condition
            Text(
              getWeatherCondition(weather!.weatherCode),
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // Weather details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Wind
                Column(
                  children: [
                    const Icon(Icons.air, size: 30),
                    const SizedBox(height: 8),
                    Text(
                      '${weather!.windSpeed.toStringAsFixed(0)} km/h',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text('Wind', style: TextStyle(color: Colors.white60)),
                  ],
                ),

                // Humidity
                Column(
                  children: [
                    const Icon(Icons.water_drop_outlined, size: 30),
                    const SizedBox(height: 8),
                    Text(
                      '${weather!.humidity.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Humidity',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),

                // Sun
                Column(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, size: 30),
                    const SizedBox(height: 8),
                    const Text(
                      '8 hr',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Sunshine',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 35),

            // Hourly for cast titles
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Hourly forcast
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  hourlyCard(
                    'Now',
                    weather!.temperature,
                    getWeatherIcon(weather!.weatherCode),
                  ),

                  hourlyCard('5 PM', weather!.temperature - 1, Icons.cloud),

                  hourlyCard('6 PM', weather!.temperature - 1.5, Icons.cloud),

                  hourlyCard(
                    '7 PM',
                    weather!.temperature - 2,
                    Icons.nightlight_round,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom navigation
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF202035),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ),

                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.map_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hourlyCard(String time, double temperature, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF19192E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          Icon(icon, size: 38, color: Colors.lightBlueAccent),

          Text(
            '${temperature.toStringAsFixed(0)}°',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
