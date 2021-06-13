import 'package:flutter/material.dart';
import 'package:nusnav/models/bus.dart';

class BusService {
  BusService({
    @required this.serviceNo,
    @required this.nextBuses,
  });

  String serviceNo;
  List<Bus> nextBuses;

  static List<BusService> toBusServiceList(List _busServices) {
    List<BusService> busServices = [];
    for (int i = 0; i < _busServices.length; i++) {
      String _serviceNo = _busServices[i]["ServiceNo"];
      Bus _nextBus1 = new Bus(
        originCode: _busServices[i]["NextBus"]["OriginCode"],
        destinationCode: _busServices[i]["NextBus"]["DestinationCode"],
        estimatedArrival: _busServices[i]["NextBus"]["EstimatedArrival"],
      );
      Bus _nextBus2 = new Bus(
        originCode: _busServices[i]["NextBus2"]["OriginCode"],
        destinationCode: _busServices[i]["NextBus2"]["DestinationCode"],
        estimatedArrival: _busServices[i]["NextBus2"]["EstimatedArrival"],
      );
      Bus _nextBus3 = new Bus(
        originCode: _busServices[i]["NextBus3"]["OriginCode"],
        destinationCode: _busServices[i]["NextBus3"]["DestinationCode"],
        estimatedArrival: _busServices[i]["NextBus3"]["EstimatedArrival"],
      );
      List<Bus> _nextBuses = [];
      _nextBuses.add(_nextBus1);
      _nextBuses.add(_nextBus2);
      _nextBuses.add(_nextBus3);
      busServices
          .add(new BusService(serviceNo: _serviceNo, nextBuses: _nextBuses));
    }
    return busServices;
  }

  @override
  String toString() {
    return serviceNo;
  }
}
