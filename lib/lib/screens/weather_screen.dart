import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/lib/blocs/weather_bloc.dart';
import 'package:weather_app/lib/network/weather_api_service.dart';

class WeatherScreen extends StatelessWidget {
  final String city;

  WeatherScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(WeatherApiService())
        ..add(FetchWeather(city: city)),
      child: Scaffold(
        appBar: AppBar(title: Text('Weather Details')),
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(child: Text('Please enter a city name'));
            } else if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WeatherLoaded) {
              final weather = state.weather;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(weather.cityName, style: TextStyle(fontSize: 24)),
                    Text('${weather.temperature} °C', style: TextStyle(fontSize: 24)),
                    Text(weather.weatherCondition, style: TextStyle(fontSize: 24)),
                    Image.network(
                      'http://openweathermap.org/img/wn/${weather.icon}@2x.png',
                      height: 100,
                      width: 100,
                    ),
                    Text('Humidity: ${weather.humidity}%', style: TextStyle(fontSize: 18)),
                    Text('Wind Speed: ${weather.windSpeed} m/s', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WeatherBloc>().add(FetchWeather(city: city));
                      },
                      child: Text('Refresh'),
                    ),
                  ],
                ),
              );
            } else if (state is WeatherError) {
              return Center(child: Text('Failed to fetch weather'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
