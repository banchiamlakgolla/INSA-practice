import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather() async {
    const url =
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=8.9806&'
        'longitude=38.7578&'
        'current=temperature_2m,relative_humidity_2m,'
        'apparent_temperature,precipitation,weather_code,'
        'wind_speed_10m,wind_direction_10m';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
