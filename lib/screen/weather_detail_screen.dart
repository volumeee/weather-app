import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../assets/weather_icons.dart';
import '../utils/date_utils.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherDetailScreen({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (weatherData.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
      );
    }

    final currentTemp = _getTemperature(0);
    final humidity = _getHumidity(0);
    final windSpeed = _getWindSpeed(0);
    final weatherCondition = _getWeatherCondition(0);

    final importDateTime = weatherData['importDateTime'] != null
        ? DateTime.parse(weatherData['importDateTime'])
        : DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMMM d, y').format(importDateTime),
              style: TextStyle(color: Colors.grey[600]),
            ),
            Row(
              children: [
                Text(
                  DateFormat('HH:mm').format(importDateTime),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(width: 5),
                Text(
                  'WIB',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 50),
            _buildMainWeatherInfo(context, weatherCondition, currentTemp),
            SizedBox(height: 50),
            _buildTodayDetails(humidity, windSpeed),
            SizedBox(height: 50),
            _buildHourlyForecast(),
          ],
        ),
      ),
    );
  }

  // Helper methods to get data safely with null checks
  String _getTemperature(int index) {
    return weatherData['temperatures'] != null &&
            weatherData['temperatures'].length > index
        ? weatherData['temperatures'][index]['temperature']?.toString() ?? 'N/A'
        : 'N/A';
  }

  String _getHumidity(int index) {
    return weatherData['humidities'] != null &&
            weatherData['humidities'].length > index
        ? weatherData['humidities'][index]['humidity']?.toString() ?? 'N/A'
        : 'N/A';
  }

  String _getWindSpeed(int index) {
    return weatherData['windSpeeds'] != null &&
            weatherData['windSpeeds'].length > index
        ? weatherData['windSpeeds'][index]['windSpeed']?.toString() ?? 'N/A'
        : 'N/A';
  }

  String _getWeatherCondition(int index) {
    final iconCode = weatherData['weatherIcons'] != null &&
            weatherData['weatherIcons'].length > index
        ? weatherData['weatherIcons'][index]['iconCode'] ?? 'unknown'
        : 'unknown';

    print('Weather icon code: $iconCode');
    return iconCode;
  }

  Widget _buildMainWeatherInfo(
      BuildContext context, String weatherCondition, String currentTemp) {
    return Center(
      child: Column(
        children: [
          Icon(
            WeatherIcons.getWeatherIcon(weatherCondition),
            size: 100,
            color: Colors.orange,
          ),
          Text(
            WeatherIcons.getWeatherDescription(weatherCondition),
            style: TextStyle(fontSize: 24, color: Colors.indigo[900]),
          ),
          Text(
            '$currentTemp°',
            style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('↑ 32°', style: TextStyle(color: Colors.grey[600])),
              SizedBox(width: 10),
              Text('↓ 25°', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDetails(String humidity, String windSpeed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Details',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900]),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeatherDetailItem(
              label: 'Humidity',
              value: '$humidity%',
              icon: Icons.water_drop,
            ),
            WeatherDetailItem(
              label: 'Wind Speed',
              value: '$windSpeed km/h',
              icon: Icons.air,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900]),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.indigo[900],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData['temperatures']?.length ?? 0,
            itemBuilder: (context, index) {
              final temp = _getTemperature(index);
              final dateTime = weatherData['temperatures'] != null
                  ? parseBMKGDate(
                      weatherData['temperatures'][index]['datetime'])
                  : null;
              final hourWeatherCondition = _getWeatherCondition(index);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateTime != null
                          ? DateFormat('HH:mm').format(dateTime)
                          : 'N/A',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Icon(
                      WeatherIcons.getWeatherIcon(hourWeatherCondition),
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$temp°',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WeatherDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  WeatherDetailItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo[900], size: 30),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }
}
