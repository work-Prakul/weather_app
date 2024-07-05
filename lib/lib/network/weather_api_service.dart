import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/lib/models/weather.dart';

class WeatherApiService {
  final String apiKey = 'e6a3c237d83a7f0265be729727847d44';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=e6a3c237d83a7f0265be729727847d44&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
