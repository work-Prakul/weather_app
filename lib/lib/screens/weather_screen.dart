import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/lib/blocs/weather_bloc.dart';
import 'package:weather_app/lib/models/weather.dart';
import 'package:weather_app/lib/network/weather_api_service.dart';

class WeatherScreen extends StatelessWidget {
  final String city;

  WeatherScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherBloc(WeatherApiService())..add(FetchWeather(city: city)),
      child: Scaffold(
        backgroundColor: Colors.teal.shade400,
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(
                  child: Text('Please enter a city name',
                      style: AppTextStyle.errorTextStyle));
            } else if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WeatherLoaded) {
              final weather = state.weather;
              return WeatherDetailScreen(weather: weather);
            } else if (state is WeatherError) {
              return Center(
                  child:
                      Text(state.message, style: AppTextStyle.errorTextStyle));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class WeatherDetailScreen extends StatelessWidget {
  final Weather weather;

  WeatherDetailScreen({required this.weather});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              weather.cityName,
              textAlign: TextAlign.center,
              style: AppTextStyle.cityTextStyle,
            ),
            SizedBox(height: 20),
            Text(
              '${weather.temperature}°',
              textAlign: TextAlign.center,
              style: AppTextStyle.temperatureTextStyle,
            ),
            Image.network(
              'http://openweathermap.org/img/wn/${weather.icon}@2x.png',
              height: 100,
              width: 100,
            ),
            Text(
              weather.weatherCondition,
              textAlign: TextAlign.center,
              style: AppTextStyle.weatherConditionTextStyle,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Humidity: ${weather.humidity}%',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.infoTextStyle,
                ),
                Text(
                  'Wind Speed: ${weather.windSpeed} m/s',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.infoTextStyle,
                ),
              ],
            ),
            SizedBox(
              width: 120,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(103, 6, 214, 145)),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 12)),
                ),
                onPressed: () {
                  context
                      .read<WeatherBloc>()
                      .add(FetchWeather(city: weather.cityName));
                },
                child:
                    Text('Refresh', style: AppTextStyle.refreshButtonTextStyle),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //insufficient data from the api
                HourlyWeatherCard(time: '2:00 AM', temp: '32°', icon: '01d'),
                HourlyWeatherCard(time: '12:00 AM', temp: '30°', icon: '02d'),
                HourlyWeatherCard(time: '8:00 AM', temp: '29°', icon: '03d'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyWeatherCard extends StatelessWidget {
  final String time;
  final String temp;
  final String icon;

  HourlyWeatherCard(
      {required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(time, style: AppTextStyle.infoTextStyle),
        Image.network(
          'http://openweathermap.org/img/wn/$icon@2x.png',
          height: 40,
          width: 40,
        ),
        Text(temp, style: AppTextStyle.infoTextStyle),
      ],
    );
  }
}

class AppTextStyle {
  static const TextStyle cityTextStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: Color.fromARGB(255, 246, 248, 247),
  );

  static const TextStyle temperatureTextStyle = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );

  static const TextStyle weatherConditionTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );

  static const TextStyle infoTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white70,
  );

  static const TextStyle refreshButtonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white70,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.red,
  );
}
