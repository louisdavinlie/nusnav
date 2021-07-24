import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nusnav/models/bus_service.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/screens/components/custom_appbar.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nusnav/services/bus_api.dart';
import 'package:nusnav/models/text_file_storage.dart';

import 'loading.dart';

class BusStopListPage extends StatefulWidget {
  final TextFileStorage nusStorage;
  final TextFileStorage publicStorage;

  const BusStopListPage({
    Key key,
    this.nusStorage,
    this.publicStorage,
  }) : super(key: key);

  @override
  _BusStopListPageState createState() => _BusStopListPageState();
}

class _BusStopListPageState extends State<BusStopListPage>
    with SingleTickerProviderStateMixin {
  bool favouriteMode = false;
  var now = DateTime.now();

  List<String> _nusFavoriteStops = [];
  List<BusStop> _nusBusStops = [];

  List<String> _publicFavoriteStops = [];
  List<BusStop> _publicBusStops = [];

  Future<void> loadPublicBusesJson() async {
    final String response =
        await rootBundle.loadString('assets/json/PublicBusArrival.json');
    final data = await json.decode(response);
    setState(() {
      _publicBusStops = List.from(BusStop.toBusStopList(data["BusStops"]));
    });
  }

  @override
  void initState() {
    super.initState();
    // this.loadNUSBusesJson();
    this.loadPublicBusesJson();
    widget.nusStorage.readFavorites().then((String favoriteList) {
      _nusFavoriteStops = favoriteList.split(' ').toList();
    });
    widget.publicStorage.readFavorites().then((String favoriteList) {
      _publicFavoriteStops = favoriteList.split(' ').toList();
    });
  }

  Future<File> _addNUSFavorite() {
    return widget.nusStorage.writeFavorites(_nusFavoriteStops);
  }

  Future<File> _addPublicFavorite() {
    return widget.publicStorage.writeFavorites(_publicFavoriteStops);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
              child: DropdownButton<String>(
                value: favouriteMode ? 'Favourites' : 'All',
                items: [
                  DropdownMenuItem(
                    child: Text('All'),
                    value: 'All',
                  ),
                  DropdownMenuItem(
                    child: Text('Favourites'),
                    value: 'Favourites',
                  ),
                ],
                onChanged: (String newValue) {
                  setState(() {
                    favouriteMode = !favouriteMode;
                  });
                },
              ),
            ),
          ],
          autoImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'NUS',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Public',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          extraAppBarHeight: 50,
        ),
        body: TabBarView(
          children: [
            nusBuses(width),
            publicBuses(),
          ],
        ),
      ),
    );
  }

  FutureBuilder nusBuses(var width) {
    return favouriteMode
        ? FutureBuilder(
            future: BusAPI.getBusStops(),
            builder: (context, snapshot) {
              _nusBusStops = snapshot.data;
              if (snapshot.hasData) {
                return _nusFavoriteStops.length == 1
                    ? Center(
                        child: Text('No Favorites'),
                      )
                    : ListView.builder(
                        itemCount: _nusFavoriteStops.length - 1,
                        itemBuilder: (context, index1) {
                          // Set a timer that periodically refreshes
                          Timer _everyminute = Timer.periodic(
                            Duration(seconds: 30),
                            (timer) {
                              setState(() {});
                            },
                          );
                          int favoriteIndex =
                              int.tryParse(_nusFavoriteStops[index1 + 1]);
                          return ExpansionTile(
                            leading: IconButton(
                              icon: Icon(Icons.star),
                              onPressed: () {
                                setState(() {
                                  _nusFavoriteStops.remove('$favoriteIndex');
                                  _addNUSFavorite();
                                });
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                            title: Text(
                              _nusBusStops[favoriteIndex].longName,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            children: <Widget>[
                              FutureBuilder(
                                future: BusAPI.getAllBusesArrivalTime(
                                    _nusBusStops[favoriteIndex].busStopName),
                                builder: (context, snapshot) {
                                  List<BusService> _services = snapshot.data;
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: _services.length,
                                      itemBuilder: (context, index2) {
                                        String arrivalMinuteBus1 =
                                            _services[index2]
                                                .nextBuses[0]
                                                .estimatedArrival;
                                        String arrivalMinuteBus2 =
                                            _services[index2]
                                                .nextBuses[1]
                                                .estimatedArrival;
                                        return ListTile(
                                          title: Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: width * 0.35,
                                                  child: Text(
                                                    _services[index2].serviceNo,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: width * 0.2,
                                                        child: Center(
                                                          child: Text(
                                                            arrivalMinuteBus1,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width * 0.2,
                                                        child: Center(
                                                          child: Text(
                                                            arrivalMinuteBus2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
              } else {
                return Loading();
              }
            },
          )
        : FutureBuilder(
            future: BusAPI.getBusStops(),
            builder: (context, snapshot) {
              _nusBusStops = snapshot.data;
              print(_nusBusStops);
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: _nusBusStops.length,
                  itemBuilder: (context, index1) {
                    // Set a timer that periodically refreshes
                    Timer _everyminute = Timer.periodic(
                      Duration(seconds: 30),
                      (timer) {
                        setState(() {});
                      },
                    );
                    return ExpansionTile(
                      onExpansionChanged: (newState) {
                        setState(() {});
                      },
                      leading: _nusFavoriteStops.contains('$index1')
                          ? IconButton(
                              icon: Icon(Icons.star),
                              onPressed: () {
                                setState(() {
                                  _nusFavoriteStops.remove('$index1');
                                  _addNUSFavorite();
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.star_outline),
                              onPressed: () {
                                setState(() {
                                  _nusFavoriteStops.add('$index1');
                                  _addNUSFavorite();
                                });
                              },
                            ),
                      trailing: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      title: Text(
                        _nusBusStops[index1].longName,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        FutureBuilder(
                          future: BusAPI.getAllBusesArrivalTime(
                              _nusBusStops[index1].busStopName),
                          builder: (context, snapshot) {
                            List<BusService> _services = snapshot.data;
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: _services.length,
                                itemBuilder: (context, index2) {
                                  String arrivalMinuteBus1 = _services[index2]
                                      .nextBuses[0]
                                      .estimatedArrival;
                                  String arrivalMinuteBus2 = _services[index2]
                                      .nextBuses[1]
                                      .estimatedArrival;
                                  return ListTile(
                                    title: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: width * 0.35,
                                            child: Text(
                                              _services[index2].serviceNo,
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: width * 0.2,
                                                  child: Center(
                                                    child: Text(
                                                      arrivalMinuteBus1,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: width * 0.2,
                                                  child: Center(
                                                    child: Text(
                                                      arrivalMinuteBus2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Loading();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Loading();
              }
            },
          );
  }

  Widget publicBuses() {
    return favouriteMode && _publicFavoriteStops.length == 1
        ? Center(
            child: Text('No Favorites'),
          )
        : favouriteMode
            ? ListView.builder(
                itemCount: _publicFavoriteStops.length - 1,
                itemBuilder: (context, index1) {
                  int favoriteIndex =
                      int.tryParse(_publicFavoriteStops[index1 + 1]);
                  return ExpansionTile(
                    leading: IconButton(
                      icon: Icon(Icons.star),
                      onPressed: () {
                        setState(() {
                          _publicFavoriteStops.remove('$favoriteIndex');
                          _addPublicFavorite();
                        });
                      },
                    ),
                    title: Text(
                      _publicBusStops[favoriteIndex].busStopName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            _publicBusStops[favoriteIndex].busServices.length,
                        itemBuilder: (context, index2) {
                          List<BusService> _services = List.from(
                              _publicBusStops[favoriteIndex].busServices);
                          String arrivalMinuteBus1 = _services[index2]
                              .nextBuses[0]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus1 =
                              int.parse(arrivalMinuteBus1) - now.minute;
                          String arrivalMinuteBus2 = _services[index2]
                              .nextBuses[1]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus2 =
                              int.parse(arrivalMinuteBus2) - now.minute;
                          String arrivalMinuteBus3 = _services[index2]
                              .nextBuses[2]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus3 =
                              int.parse(arrivalMinuteBus3) - now.minute;
                          return ListTile(
                            title: Center(
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Center(
                                      child: Text(
                                        _services[index2].serviceNo,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus1.toString()),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus2.toString()),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus3.toString()),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              )
            : ListView.builder(
                itemCount: favouriteMode
                    ? _publicFavoriteStops.length - 1
                    : _publicBusStops.length,
                itemBuilder: (context, index1) {
                  return ExpansionTile(
                    leading: _publicFavoriteStops.contains('$index1')
                        ? IconButton(
                            icon: Icon(Icons.star),
                            onPressed: () {
                              setState(() {
                                _publicFavoriteStops.remove('$index1');
                                _addPublicFavorite();
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.star_outline),
                            onPressed: () {
                              setState(() {
                                _publicFavoriteStops.add('$index1');
                                _addPublicFavorite();
                              });
                            },
                          ),
                    title: Text(
                      _publicBusStops[index1].busStopName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: _publicBusStops[index1].busServices.length,
                        itemBuilder: (context, index2) {
                          List<BusService> _services =
                              List.from(_publicBusStops[index1].busServices);
                          String arrivalMinuteBus1 = _services[index2]
                              .nextBuses[0]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus1 =
                              int.parse(arrivalMinuteBus1) - now.minute;
                          String arrivalMinuteBus2 = _services[index2]
                              .nextBuses[1]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus2 =
                              int.parse(arrivalMinuteBus2) - now.minute;
                          String arrivalMinuteBus3 = _services[index2]
                              .nextBuses[2]
                              .estimatedArrival
                              .substring(14, 16);
                          int minuteUntilArrivalBus3 =
                              int.parse(arrivalMinuteBus3) - now.minute;
                          return ListTile(
                            title: Center(
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Center(
                                      child: Text(
                                        _services[index2].serviceNo,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus1.toString()),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus2.toString()),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(
                                            minuteUntilArrivalBus3.toString()),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
  }
}
