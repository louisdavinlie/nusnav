import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusnav/models/bus_service.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/models/nus_favorite_storage.dart';
import 'package:nusnav/models/public_favorite_storage.dart';

import 'components/appbar.dart';
import 'loading.dart';

class Favorites extends StatefulWidget {
  final NUSFavoriteStorage nusStorage;
  final PublicFavoriteStorage publicStorage;

  const Favorites({
    Key key,
    this.nusStorage,
    this.publicStorage,
  }) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with SingleTickerProviderStateMixin {
  var now = DateTime.now();

  List<String> _nusFavoriteStops = [];
  List<BusStop> _nusBusStops = [];

  List<String> _publicFavoriteStops = [];
  List<BusStop> _publicBusStops = [];

  Future<void> loadNUSBusesJson() async {
    final String response =
        await rootBundle.loadString('assets/json/NUSBusArrival.json');
    final data = await json.decode(response);
    setState(() {
      _nusBusStops = List.from(BusStop.toBusStopList(data["BusStops"]));
    });
  }

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
    this.loadNUSBusesJson();
    this.loadPublicBusesJson();
    widget.nusStorage.readFavorites().then((String favoriteList) {
      setState(() {
        _nusFavoriteStops = favoriteList.split(' ').toList();
      });
    });
    widget.publicStorage.readFavorites().then((String favoriteList) {
      setState(() {
        _publicFavoriteStops = favoriteList.split(' ').toList();
      });
    });
  }

  Future<File> _addNUSFavorite() {
    return widget.nusStorage.writeFavorites(_nusFavoriteStops);
  }

  Future<File> _addPublicFavorite() {
    return widget.publicStorage.writeFavorites(_publicFavoriteStops);
  }

  @override
  Widget build(BuildContext context) {
    return _nusFavoriteStops == null ||
            _nusFavoriteStops.length == 0 ||
            _publicFavoriteStops == null ||
            _publicFavoriteStops.length == 0
        ? Loading()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: CustomAppBar(
                autoImplyLeading: false,
                text1: 'NUS',
                text2: 'nav',
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
                extraAppBarHeight: 40,
              ),
              body: TabBarView(
                children: [
                  nusBuses(),
                  publicBuses(),
                ],
              ),
            ),
          );
  }

  Widget nusBuses() {
    return _nusFavoriteStops.length == 1
        ? Center(
            child: Text('No Favorites'),
          )
        : ListView.builder(
            itemCount: _nusFavoriteStops.length - 1,
            itemBuilder: (context, index1) {
              int favoriteIndex = int.tryParse(_nusFavoriteStops[index1 + 1]);
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
                title: Text(
                  _nusBusStops[favoriteIndex].busStopName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _nusBusStops[favoriteIndex].busServices.length,
                    itemBuilder: (context, index2) {
                      List<BusService> _services =
                          List.from(_nusBusStops[favoriteIndex].busServices);
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
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus1.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus2.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus3.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  )
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

  Widget publicBuses() {
    return _publicFavoriteStops.length == 1
        ? Center(
            child: Text('No Favorites'),
          )
        : ListView.builder(
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
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount:
                        _publicBusStops[favoriteIndex].busServices.length,
                    itemBuilder: (context, index2) {
                      List<BusService> _services =
                          List.from(_publicBusStops[favoriteIndex].busServices);
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
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus1.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus2.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Text(minuteUntilArrivalBus3.toString()),
                                        Text('mins'),
                                      ],
                                    ),
                                  )
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
