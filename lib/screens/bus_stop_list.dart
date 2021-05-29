import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusnav/screens/components/appbar.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nusnav/services/favorite_storage.dart';

class BusStopList extends StatefulWidget {
  final FavoriteStorage storage;

  const BusStopList({Key key, this.storage}) : super(key: key);

  @override
  _BusStopListState createState() => _BusStopListState();
}

class _BusStopListState extends State<BusStopList> {
  // List<String> _favorites = [];
  // String _busStopCode = '';
  // String _busStopName = '';
  // List _services = [];
  // var now = DateTime.now();

  // Future<void> loadJsonData() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/BusArrival.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _busStopCode = data["BusStopCode"];
  //     _busStopName = data["BusStopName"];
  //     _services = data["Services"];
  //   });
  // }

  List<String> _favorites = [];

  List _busStops = [];

  String _busStopName = '';
  List _services = [];
  var now = DateTime.now();

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/json/BusArrival.json');
    final data = await json.decode(response);
    setState(() {
      _busStops = data["BusStops"];
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
    widget.storage.readFavorites().then((String favoriteList) {
      setState(() {
        _favorites = favoriteList.split(' ').toList();
      });
    });
  }

  Future<File> _addFavorite() {
    return widget.storage.writeFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          autoImplyLeading: false,
          text1: 'NUS',
          text2: 'nav',
        ),
        body: ListView.builder(
          itemCount: _busStops.length,
          itemBuilder: (context, index1) {
            _busStopName = _busStops[index1]["BusStopName"];
            return ExpansionTile(
              leading: _favorites.contains('$index1')
                  ? IconButton(
                      icon: Icon(Icons.star),
                      onPressed: () {
                        setState(() {
                          _favorites.remove('$index1');
                          _addFavorite();
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.star_outline),
                      onPressed: () {
                        setState(() {
                          _favorites.add('$index1');
                          _addFavorite();
                        });
                      },
                    ),
              title: Text(
                _busStopName,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _busStops[index1]["Services"].length,
                  itemBuilder: (context, index2) {
                    _services = _busStops[index1]["Services"];
                    String arrivalMinuteBus1 = _services[index2]["NextBus"]
                            ["EstimatedArrival"]
                        .substring(14, 16);
                    int minuteUntilArrivalBus1 =
                        int.parse(arrivalMinuteBus1) - now.minute;
                    String arrivalMinuteBus2 = _services[index2]["NextBus2"]
                            ["EstimatedArrival"]
                        .substring(14, 16);
                    int minuteUntilArrivalBus2 =
                        int.parse(arrivalMinuteBus2) - now.minute;
                    String arrivalMinuteBus3 = _services[index2]["NextBus3"]
                            ["EstimatedArrival"]
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
                                  _services[index2]["ServiceNo"],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(20,10,20,10),
                                  child: Column(
                                    children: [
                                      Text(minuteUntilArrivalBus1.toString()),
                                      Text('mins'),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20,10,20,10),
                                  child: Column(
                                    children: [
                                      Text(minuteUntilArrivalBus2.toString()),
                                      Text('mins'),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20,10,20,10),
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
        ));
  }
}
