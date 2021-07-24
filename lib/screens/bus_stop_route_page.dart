import 'package:flutter/material.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/models/bus_stop_graph.dart';
import 'package:nusnav/services/bus_api.dart';
import 'package:timelines/timelines.dart';
import 'components/custom_appbar.dart';
import 'loading.dart';
import 'package:nusnav/components/auto_textfield.dart';

class BusStopRoutePage extends StatefulWidget {
  @override
  _BusStopRoutePageState createState() => _BusStopRoutePageState();
}

class _BusStopRoutePageState extends State<BusStopRoutePage> {
  BusStop _originBusStop;
  BusStop _destinationBusStop;
  TextEditingController _originBusStopTextEditingController;
  TextEditingController _destinationBusStopTextEditingController;
  TextEditingController _noOfBusesTextEditingController;
  TextEditingController _sortByTextEditingController;
  int _maxNoOfBusToTake = 2;
  String _sortBy = "Buses";
  List<BusStop> _nusBusStops;
  Set<String> _busStopNames;
  BusStop findBusStop(String busStopName) {
    return _nusBusStops.firstWhere((BusStop element) {
      return element.shortName == busStopName ||
          element.longName == busStopName ||
          element.busStopName == busStopName;
    });
  }

  _loadNUSBusesJson() async {
    List<BusStop> nusBusStops = await BusAPI.getBusStops();
    setState(() {
      _nusBusStops = List.from(nusBusStops);
      _busStopNames = _nusBusStops
          .map((busStop) => {
                busStop.busStopName,
                busStop.longName,
                busStop.shortName,
              })
          .toList()
          .reduce(
        (Set<String> value, Set<String> element) {
          value.addAll(element);
          return value;
        },
      );
    });
  }

  void _initControllers() {
    _originBusStopTextEditingController = TextEditingController();
    _destinationBusStopTextEditingController = TextEditingController();
    _noOfBusesTextEditingController = TextEditingController();
    _sortByTextEditingController = TextEditingController();
  }

  void _disposeControllers() {
    _originBusStopTextEditingController.dispose();
    _destinationBusStopTextEditingController.dispose();
    _noOfBusesTextEditingController.dispose();
    _sortByTextEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadNUSBusesJson();
    _initControllers();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeControllers();
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
                setOriginBusStopField(),
                setDestinationBusStopField(),
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
              _originBusStop,
              _destinationBusStop,
              _maxNoOfBusToTake,
              width,
            ),
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

  Widget setOriginBusStopField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: AutoCompTextField(
        hintText: 'Starting BusStop',
        labelText: 'Starting BusStop',
        options: _busStopNames,
        onSuggestionSelected: (String suggestion) {
          setState(() {
            _originBusStop = findBusStop(suggestion);
          });
        },
        textEditingController: _originBusStopTextEditingController,
      ),
    );
  }

  Widget setDestinationBusStopField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: AutoCompTextField(
        hintText: 'Destination BusStop',
        labelText: 'Destination BusStop',
        options: _busStopNames,
        onSuggestionSelected: (String suggestion) {
          setState(() {
            _destinationBusStop = findBusStop(suggestion);
          });
        },
        textEditingController: _destinationBusStopTextEditingController,
      ),
    );
  }

  FutureBuilder originBusStopsDropdown() {
    return FutureBuilder(
      future: BusAPI.getBusStops(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: DropdownButtonFormField<BusStop>(
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
              onChanged: (BusStop value) {
                setState(() {
                  _originBusStop = value;
                });
              },
              items: snapshot.data.map<DropdownMenuItem<BusStop>>(
                (BusStop value) {
                  return DropdownMenuItem<BusStop>(
                    value: value,
                    child: Text(value.toString()),
                  );
                },
              ).toList(),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  FutureBuilder destinationBusStopsDropdown() {
    return FutureBuilder(
      future: BusAPI.getBusStops(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: DropdownButtonFormField<BusStop>(
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
              onChanged: (BusStop value) {
                setState(() {
                  _destinationBusStop = value;
                });
              },
              items: snapshot.data.map<DropdownMenuItem<BusStop>>(
                (BusStop value) {
                  return DropdownMenuItem<BusStop>(
                    value: value,
                    child: Text(value.toString()),
                  );
                },
              ).toList(),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  FutureBuilder<List> buildBusRouteCalculator(
    BusStop originBusStop,
    BusStop destinationBusStop,
    int maxNoOfBusToTake,
    var width,
  ) {
    return FutureBuilder(
      future: BusStopGraph.findPath(
        originBusStop,
        destinationBusStop,
        [
          ["Walk to", originBusStop]
        ],
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
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            FixedTimeline.tileBuilder(
                              theme: TimelineThemeData(
                                nodePosition: 0,
                              ),
                              builder: TimelineTileBuilder.connected(
                                connectionDirection: ConnectionDirection.before,
                                connectorBuilder: (_, index2, connectorType) {
                                  var color;
                                  String busNo =
                                      snapshot.data[index][0][index2][0];
                                  color = busNo == "A1"
                                      ? Colors.red
                                      : busNo == "A2"
                                          ? Colors.yellow
                                          : busNo == "D1"
                                              ? Colors.pink
                                              : busNo == "D2"
                                                  ? Colors.indigo
                                                  : busNo == "K"
                                                      ? Colors.blue
                                                      : busNo == "E"
                                                          ? Colors.green
                                                          : busNo == "BTC"
                                                              ? Colors.orange
                                                              : busNo == "L"
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .brown;
                                  return SolidLineConnector(
                                    color: color,
                                  );
                                },
                                indicatorBuilder: (context, index2) {
                                  var color;
                                  String busNo =
                                      snapshot.data[index][0][index2][0];
                                  color = busNo == "A1"
                                      ? Colors.red
                                      : busNo == "A2"
                                          ? Colors.yellow
                                          : busNo == "D1"
                                              ? Colors.pink
                                              : busNo == "D2"
                                                  ? Colors.indigo
                                                  : busNo == "K"
                                                      ? Colors.blue
                                                      : busNo == "E"
                                                          ? Colors.green
                                                          : busNo == "BTC"
                                                              ? Colors.orange
                                                              : busNo == "L"
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .brown;
                                  return DotIndicator(
                                    color: color,
                                    position: 0.5,
                                  );
                                },
                                contentsAlign: ContentsAlign.basic,
                                contentsBuilder: (context, index2) {
                                  String busService =
                                      snapshot.data[index][0][index2][0];
                                  BusStop busStop =
                                      snapshot.data[index][0][index2][1];
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      busService + ' - ' + busStop.longName,
                                    ),
                                  );
                                },
                                itemCount: snapshot.data[index][0].length,
                              ),
                            ),
                          ],
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
