import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class WeatherService {
  static const String _baseUrl =
      'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-Indonesia.xml';

  Future<List<Map<String, dynamic>>> getWeatherData() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final areas = document.findAllElements('area');

      return areas.map((area) {
        final areaName = area.getAttribute('description') ?? '';
        final id = area.getAttribute('id') ?? '';
        final latitude = area.getAttribute('latitude') ?? '';
        final longitude = area.getAttribute('longitude') ?? '';

        final temperatures = area
            .findElements('parameter')
            .where((param) => param.getAttribute('id') == 't')
            .expand((param) => param.findElements('timerange'))
            .map((timerange) {
          final datetime = timerange.getAttribute('datetime') ?? '';
          final tempC = timerange
              .findElements('value')
              .firstWhere((value) => value.getAttribute('unit') == 'C')
              .text;
          return {'datetime': datetime, 'temperature': tempC};
        }).toList();

        final humidities = area
            .findElements('parameter')
            .where((param) => param.getAttribute('id') == 'hu')
            .expand((param) => param.findElements('timerange'))
            .map((timerange) {
          final datetime = timerange.getAttribute('datetime') ?? '';
          final humidity = timerange.findElements('value').first.text;
          return {'datetime': datetime, 'humidity': humidity};
        }).toList();

        final windSpeeds = area
            .findElements('parameter')
            .where((param) => param.getAttribute('id') == 'ws')
            .expand((param) => param.findElements('timerange'))
            .map((timerange) {
          final datetime = timerange.getAttribute('datetime') ?? '';
          final windSpeed = timerange
              .findElements('value')
              .firstWhere((value) => value.getAttribute('unit') == 'KPH')
              .text;
          return {'datetime': datetime, 'windSpeed': windSpeed};
        }).toList();

        final weatherIcons = area
            .findElements('parameter')
            .where((param) => param.getAttribute('id') == 'weather')
            .expand((param) => param.findElements('timerange'))
            .map((timerange) {
          final datetime = timerange.getAttribute('datetime') ?? '';
          final iconCode = timerange.findElements('value').first.text;
          return {'datetime': datetime, 'iconCode': iconCode};
        }).toList();

        return {
          'areaName': areaName,
          'id': id,
          'latitude': latitude,
          'longitude': longitude,
          'temperatures': temperatures,
          'humidities': humidities,
          'windSpeeds': windSpeeds,
          'weatherIcons': weatherIcons,
        };
      }).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
