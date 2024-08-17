import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '0':
        return Icons.wb_sunny; // Clear Sky
      case '1':
        return Icons.wb_sunny; // Clear Sky
      case '2':
        return Icons.cloud_queue; // Partly Cloudy
      case '3':
        return Icons.cloud; // Cloudy
      case '4':
        return Icons.beach_access; // Rainy
      case '9':
        return Icons.grain; // Drizzle
      case '10':
        return Icons.beach_access; // Rain
      case '11':
        return Icons.flash_on; // Thunderstorm
      case '13':
        return Icons.ac_unit; // Snow
      case '50':
        return Icons.blur_on; // Mist
      default:
        return Icons.help_outline; // Unknown condition
    }
  }

  static String getWeatherDescription(String iconCode) {
    switch (iconCode) {
      case '0':
      case '1':
        return 'Clear Sky';
      case '2':
        return 'Partly Cloudy';
      case '3':
        return 'Cloudy';
      case '4':
        return 'Rainy';
      case '9':
        return 'Drizzle';
      case '10':
        return 'Rain';
      case '11':
        return 'Thunderstorm';
      case '13':
        return 'Snow';
      case '50':
        return 'Mist';
      default:
        return 'Unknown';
    }
  }
}
