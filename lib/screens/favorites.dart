import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusnav/models/favorite_storage.dart';

import 'components/appbar.dart';
import 'loading.dart';

class Favorites extends StatefulWidget {
  final FavoriteStorage storage;

  const Favorites({Key key, this.storage}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<String> _favorites = [];

  List _busStops = [];

  String _busStopName = '';
  List _services = [];
  var now = DateTime.now();

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/json/NUSBusArrival.json');
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

  removeFavorite(String favoriteIndex) {
    setState(() {
      _favorites.remove(favoriteIndex);
      _addFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _favorites == null || _favorites.length == 0
        ? Loading()
        : Scaffold(
            appBar: CustomAppBar(
              autoImplyLeading: false,
              text1: 'NUS',
              text2: 'nav',
            ),
            body: _favorites.length == 1
                ? Center(child: Text('No Favorites'))
                : ListView.builder(
                    itemCount: _favorites.length - 1,
                    itemBuilder: (context, index1) {
                      int favoriteIndex = int.tryParse(_favorites[index1 + 1]);
                      _busStopName = _busStops[favoriteIndex]["BusStopName"];
                      return ExpansionTile(
                        leading: IconButton(
                          icon: Icon(Icons.star),
                          onPressed: () {
                            removeFavorite('$favoriteIndex');
                          },
                        ),
                        title: Text(
                          _busStopName,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                _busStops[favoriteIndex]["Services"].length,
                            itemBuilder: (context, index2) {
                              _services = _busStops[favoriteIndex]["Services"];
                              String arrivalMinuteBus1 = _services[index2]
                                      ["NextBus"]["EstimatedArrival"]
                                  .substring(14, 16);
                              int minuteUntilArrivalBus1 =
                                  int.parse(arrivalMinuteBus1) - now.minute;
                              String arrivalMinuteBus2 = _services[index2]
                                      ["NextBus2"]["EstimatedArrival"]
                                  .substring(14, 16);
                              int minuteUntilArrivalBus2 =
                                  int.parse(arrivalMinuteBus2) - now.minute;
                              String arrivalMinuteBus3 = _services[index2]
                                      ["NextBus3"]["EstimatedArrival"]
                                  .substring(14, 16);
                              int minuteUntilArrivalBus3 =
                                  int.parse(arrivalMinuteBus3) - now.minute;
                              return ListTile(
                                title: Center(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Center(
                                          child: Text(
                                            _services[index2]["ServiceNo"],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            child: Column(
                                              children: [
                                                Text(minuteUntilArrivalBus1
                                                    .toString()),
                                                Text('mins'),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            child: Column(
                                              children: [
                                                Text(minuteUntilArrivalBus2
                                                    .toString()),
                                                Text('mins'),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            child: Column(
                                              children: [
                                                Text(minuteUntilArrivalBus3
                                                    .toString()),
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
                  ),
          );
  }
}
