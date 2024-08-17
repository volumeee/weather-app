import 'package:intl/intl.dart';

DateTime? parseBMKGDate(String dateString) {
  if (dateString.length != 12) return null;

  try {
    int year = int.parse(dateString.substring(0, 4));
    int month = int.parse(dateString.substring(4, 6));
    int day = int.parse(dateString.substring(6, 8));
    int hour = int.parse(dateString.substring(8, 10));
    int minute = int.parse(dateString.substring(10, 12));

    return DateTime(year, month, day, hour, minute);
  } catch (e) {
    print('Error parsing date: $e');
    return null;
  }
}

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm');
  return formatter.format(dateTime);
}
