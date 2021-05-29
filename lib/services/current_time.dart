import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CurrentTime {
  String time;

  Future<void> getTime() async {
    // Request for the time

    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/Singapore');
      Map data = jsonDecode(response.body);

      // Properties of data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // Create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      // Set the time property
      time = DateFormat.jm().format(now);
    } catch (e) {
      print(e);
    }
  }
}
