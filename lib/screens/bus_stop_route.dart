import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/models/bus_stop_graph.dart';
import 'package:nusnav/services/bus_api.dart';

import 'components/appbar.dart';
import 'loading.dart';
import 'package:timelines/timelines.dart';

class BusStopRoute extends StatefulWidget {
  @override
  _BusStopRouteState createState() => _BusStopRouteState();
}

class _BusStopRouteState extends State<BusStopRoute> {
  String _originBusStop = "AS 5";
  String _destinationBusStop = "AS 5";
  int _maxNoOfBusToTake = 2;
  String _sortBy = "Buses";
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
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                originBusStopsDropdown(),
                destinationBusStopsDropdown(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    maxNoOfBusesDropdown(width * 0.3),
                    sortByDropdown(width * 0.5),
                  ],
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

  Container sortByDropdown(double width) {
    return Container(
      width: width,
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Sort By',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
        value: _sortBy,
        icon: Icon(Icons.arrow_downward),
        onChanged: (String value) {
          setState(() {
            _sortBy = value;
          });
        },
        items: <String>["Buses", "Stops"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
      ),
    );
  }

  Container maxNoOfBusesDropdown(double width) {
    return Container(
      width: width,
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField<int>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'No of Buses',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
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
    );
  }

  Container originBusStopsDropdown() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Starting Bus Stop',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
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
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Destination Bus Stop',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
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

  FutureBuilder<List> buildBusRouteCalculator(
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
          if (_sortBy == "Buses") {
            snapshot.data.sort((a, b) => a[1][1] == b[1][1]
                ? a[1][2].compareTo(b[1][2])
                : a[1][1].compareTo(b[1][1]));
          } else {
            snapshot.data.sort((a, b) => a[1][2] == b[1][2]
                ? a[1][1].compareTo(b[1][1])
                : a[1][2].compareTo(b[1][2]));
          }
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Route ' + (index + 1).toString(),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data[index][1][1] == 1
                              ? Container(
                                  child: Text(
                                    '${snapshot.data[index][1][1]} Bus',
                                  ),
                                )
                              : Container(
                                  child: Text(
                                      '${snapshot.data[index][1][1]} Buses'),
                                ),
                          snapshot.data[index][1][2] == 1
                              ? Container(
                                  child: Text(
                                      '${snapshot.data[index][1][2]} Stop'),
                                )
                              : Container(
                                  child: Text(
                                      '${snapshot.data[index][1][2]} Stops'),
                                ),
                        ],
                      )
                    ],
                  ),
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: Colors.black,
                      //     width: 1,
                      //   ),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FixedTimeline.tileBuilder(
                          theme: TimelineThemeData(
                            nodePosition: 0,
                          ),
                          builder: TimelineTileBuilder.connected(
                            // connectorBuilder: (context, index) =>
                            //     SolidLineConnector(),
                            // indicatorStyleBuilder: (context, index) =>
                            //     IndicatorStyle.outlined,
                            connectorBuilder: (_, index2, connectorType) {
                              var color;
                              String busNo = snapshot.data[index][0][index2][0];
                              color = busNo == "A1"
                                  ? Colors.red
                                  : busNo == "A2"
                                      ? Colors.yellow
                                      : busNo == "B1"
                                          ? Colors.blue
                                          : busNo == "B2"
                                              ? Colors.green
                                              : busNo == "C"
                                                  ? Colors.indigo
                                                  : busNo == "D1"
                                                      ? Colors.purple
                                                      : busNo == "D2"
                                                          ? Colors.pink
                                                          : busNo == "BTC1"
                                                              ? Colors.orange
                                                              : busNo == "BTC2"
                                                                  ? Colors.brown
                                                                  : busNo ==
                                                                          "A1E"
                                                                      ? Colors
                                                                          .lime
                                                                      : Colors
                                                                          .teal;
                              return SolidLineConnector(
                                indent: connectorType == ConnectorType.start
                                    ? 0
                                    : 2.0,
                                endIndent: connectorType == ConnectorType.end
                                    ? 0
                                    : 2.0,
                                color: color,
                              );
                            },
                            indicatorBuilder: (context, index2) {
                              var color;
                              String busNo = snapshot.data[index][0][index2][0];
                              color = busNo == "A1"
                                  ? Colors.red
                                  : busNo == "A2"
                                      ? Colors.yellow
                                      : busNo == "B1"
                                          ? Colors.blue
                                          : busNo == "B2"
                                              ? Colors.green
                                              : busNo == "C"
                                                  ? Colors.indigo
                                                  : busNo == "D1"
                                                      ? Colors.purple
                                                      : busNo == "D2"
                                                          ? Colors.pink
                                                          : busNo == "BTC1"
                                                              ? Colors.orange
                                                              : busNo == "BTC2"
                                                                  ? Colors.brown
                                                                  : busNo ==
                                                                          "A1E"
                                                                      ? Colors
                                                                          .lime
                                                                      : Colors
                                                                          .teal;
                              return DotIndicator(
                                color: color,
                              );
                            },
                            contentsAlign: ContentsAlign.basic,
                            contentsBuilder: (context, index2) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Text(snapshot.data[index][0][index2][0] +
                                    ' - ' +
                                    snapshot.data[index][0][index2][1]),
                              );
                            },
                            itemCount: snapshot.data[index][0].length,
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
