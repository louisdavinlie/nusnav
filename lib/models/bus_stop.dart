import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusnav/models/bus_service.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:nusnav/services/bus_api.dart';

class BusStop {
  BusStop({
    @required this.busStopName,
    this.longName,
    this.shortName,
    this.busServices,
    this.latitude,
    this.longitude,
  });

  String busStopName;
  String longName;
  String shortName;
  List<BusService> busServices;
  double latitude;
  double longitude;

  static List<BusStop> toBusStopList(List _busStops) {
    List<BusStop> busStops = [];
    for (int i = 0; i < _busStops.length; i++) {
      String _busStopName = _busStops[i]["BusStopName"];
      List<BusService> _busServices =
          BusService.toBusServiceList(_busStops[i]["Services"]);
      busStops.add(
          new BusStop(busStopName: _busStopName, busServices: _busServices));
    }
    return busStops;
  }

  static List<BusStop> fromJsonToBusStopList(Map jsonInfo) {
    List<BusStop> busStops = [];
    List _busStops = jsonInfo['BusStopsResult']['busstops'];
    for (int i = 0; i < _busStops.length; i++) {
      String _busStopName = _busStops[i]['name'];
      String _longName = _busStops[i]['LongName'];
      String _shortName = _busStops[i]['ShortName'];
      double _latitude = _busStops[i]['latitude'];
      double _longitude = _busStops[i]['longitude'];
      // List<BusService> _busServices =
      //     await BusAPI.getAllBusesArrivalTime(_busStopName);
      busStops.add(BusStop(
        busStopName: _busStopName,
        longName: _longName,
        shortName: _shortName,
        // busServices: _busServices,
        latitude: _latitude,
        longitude: _longitude,
      ));
    }
    return busStops;
  }

  @override
  String toString() {
    // TODO: implement toString
    return longName;
  }

  bool operator ==(dynamic other) =>
      other != null && other is BusStop && this.busStopName == other.busStopName;

  @override
  int get hashCode => super.hashCode;
}
