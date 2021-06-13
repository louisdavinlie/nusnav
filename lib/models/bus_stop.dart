import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusnav/models/bus_service.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class BusStop {
  BusStop({
    @required this.busStopName,
    @required this.busServices,
  });

  String busStopName;
  List<BusService> busServices;

  static List<BusStop> toBusStopList(List _busStops) {
    List<BusStop> busStops = [];
    for (int i = 0; i < _busStops.length; i++) {
      String _busStopName = _busStops[i]["BusStopName"];
      List<BusService> _busServices =
          BusService.toBusServiceList(_busStops[i]["Services"]);
      busStops
          .add(new BusStop(busStopName: _busStopName, busServices: _busServices));
    }
    return busStops;
  }
}
