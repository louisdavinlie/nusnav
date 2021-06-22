import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/models/bus_stop_graph.dart';

import 'components/appbar.dart';
import 'loading.dart';

class BusStopRoute extends StatefulWidget {
  @override
  _BusStopRouteState createState() => _BusStopRouteState();
}

class _BusStopRouteState extends State<BusStopRoute> {
  String _originBusStop = "AS 5";
  String _destinationBusStop = "AS 5";
  int _maxNoOfBusToTake = 3;
  List<BusStop> _nusBusStops = [];

  Future<void> loadNUSBusesJson() async {
    final String response =
        await rootBundle.loadString('assets/json/NUSBusArrival.json');
    final data = await json.decode(response);
    setState(() {
      _nusBusStops = List.from(BusStop.toBusStopList(data["BusStops"]));
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadNUSBusesJson();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        autoImplyLeading: false,
        text1: 'NUS',
        text2: 'nav',
        extraAppBarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                originBusStopsDropdown(),
                destinationBusStopsDropdown(),
                Container(
                  child: DropdownButton<int>(
                    value: _maxNoOfBusToTake,
                    icon: Icon(Icons.arrow_downward),
                    onChanged: (int value) {
                      setState(() {
                        _maxNoOfBusToTake = value;
                      });
                    },
                    items: <int>[1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: buildBusRouteCalculator(
                _originBusStop, _destinationBusStop, _maxNoOfBusToTake),
          ),
        ],
      ),
    );
  }

  Container originBusStopsDropdown() {
    return Container(
      child: DropdownButton<String>(
        value: _originBusStop,
        icon: Icon(Icons.arrow_downward),
        onChanged: (String value) {
          setState(() {
            _originBusStop = value;
          });
        },
        items: _nusBusStops
            .map(
              (BusStop busStop) {
                return busStop.busStopName;
              },
            )
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
      ),
    );
  }

  Container destinationBusStopsDropdown() {
    return Container(
      child: DropdownButton<String>(
        value: _destinationBusStop,
        icon: Icon(Icons.arrow_downward),
        onChanged: (String value) {
          setState(() {
            _destinationBusStop = value;
          });
        },
        items: _nusBusStops
            .map(
              (BusStop busStop) {
                return busStop.busStopName;
              },
            )
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
      ),
    );
  }

  FutureBuilder<List<List<String>>> buildBusRouteCalculator(
      String originBusStop, String destinationBusStop, int maxNoOfBusToTake) {
    return FutureBuilder(
      future: BusStopGraph.findPath(
        originBusStop,
        destinationBusStop,
        [],
        ["", 0, 0],
        maxNoOfBusToTake,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text('Route ' + (index + 1).toString()),
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: Colors.black,
                      //     width: 1,
                      //   ),
                      // ),
                      child: ListTile(
                        title: Container(
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Text(
                            '${snapshot.data[index]}',
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
