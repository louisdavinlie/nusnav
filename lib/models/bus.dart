import 'package:flutter/material.dart';

class Bus {
  Bus({
    @required this.originCode,
    @required this.destinationCode,
    @required this.estimatedArrival,
  });

  String originCode;
  String destinationCode;
  String estimatedArrival;

  @override
  String toString() {
    return originCode;
  }
}
