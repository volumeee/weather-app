import 'package:flutter/material.dart';
import '../service/weather_service.dart';
import 'weather_detail_screen.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  List<Map<String, dynamic>> _weatherData = [];
  Map<String, dynamic>? _selectedArea;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await _weatherService.getWeatherData();
      setState(() {
        _weatherData = data;
        if (_weatherData.isNotEmpty) {
          _selectedArea = data.first;
        }
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  void _onAreaSelected(Map<String, dynamic>? newSelectedArea) {
    setState(() {
      _selectedArea = newSelectedArea;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherData.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: DropdownButton<Map<String, dynamic>>(
          value: _selectedArea,
          icon: Icon(Icons.arrow_drop_down, color: Colors.indigo[900]),
          underline: SizedBox(),
          onChanged: (Map<String, dynamic>? newValue) {
            _onAreaSelected(newValue);
          },
          items: _weatherData.map<DropdownMenuItem<Map<String, dynamic>>>(
              (Map<String, dynamic> value) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: value,
              child: Text(
                value['areaName'] ?? 'Unknown Area', // Updated key
                style: TextStyle(
                  color: Colors.indigo[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: _selectedArea != null
          ? WeatherDetailScreen(weatherData: _selectedArea!)
          : Center(child: Text('No area selected')),
    );
  }
}
