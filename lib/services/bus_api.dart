import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nusnav/models/bus.dart';
import 'package:nusnav/models/bus_service.dart';
import 'dart:async';
import 'dart:io';

import 'package:nusnav/models/bus_stop.dart';

class BusAPI {
  static Future<List<BusStop>> getBusStops() async {
    var response = await http.get(
      'https://nnextbus.nus.edu.sg/BusStops',
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic TlVTbmV4dGJ1czoxM2RMP3pZLDNmZVdSXiJU',
      },
    );

    List<BusStop> busStopList = [];

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      busStopList =
          List.from(await BusStop.fromJsonToBusStopList(responseJson));
    }

    return busStopList;
  }

  static Future<List<BusService>> getAllBusesArrivalTime(
      String busStopName) async {
    var response = await http.get(
      'https://nnextbus.nus.edu.sg/ShuttleService?busstopname=$busStopName',
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic TlVTbmV4dGJ1czoxM2RMP3pZLDNmZVdSXiJU',
      },
    );

    List<BusService> busServiceList = [];

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      busServiceList =
          List.from(BusService.fromJsonToBusServiceList(responseJson));
    }

    return busServiceList;
  }
}
