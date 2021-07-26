import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:nusnav/models/bus_stop.dart';
import 'package:nusnav/screens/choose_route.dart';
import 'package:nusnav/services/bus_api.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:geocoding/geocoding.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController mapController;
  PickResult selectedStartPlace;
  PickResult selectedDestinationPlace;

  BusStop nearestToStart;
  BusStop nearestToDestination;

  final LatLng _center = const LatLng(1.2966, 103.7764);

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  // Object for PolylinePoints
  PolylinePoints polylinePoints;

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> markers = {};
  List<LatLng> latLngList = [];

  Position _currentPosition;

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  _addNUSBusStopsMarkers() async {
    List<BusStop> _nusBusStops = List<BusStop>.from(await BusAPI.getBusStops());
    _addBusStopMarkers(_nusBusStops);
  }

  _addBusStopMarkers(List<BusStop> busStops) {
    setState(() {
      Set<Marker> _markers = {};
      for (int i = 0; i < busStops.length; i++) {
        BusStop busStop = busStops[i];
        double busStopLatitude = busStop.latitude;
        double busStopLongitude = busStop.longitude;
        String busStopName = busStop.longName;
        String busStopCoordinatesString =
            '($busStopLatitude, $busStopLongitude)';
        Marker busStopMarker = Marker(
          markerId: MarkerId(busStopCoordinatesString),
          position: LatLng(busStopLatitude, busStopLongitude),
          infoWindow: InfoWindow(
            title: '$busStopName',
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        _markers.add(busStopMarker);
      }
      markers = Set<Marker>.from(_markers);
    });
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<List<Location>> _pickResultToLatLng(PickResult location) async {
    return await locationFromAddress(location.formattedAddress);
  }

  Future<BusStop> _findNearestBusStop(PickResult location) async {
    List<Location> _location = await _pickResultToLatLng(location);
    BusStop nearestBusStop;
    double distanceSoFar = double.infinity;
    List<BusStop> _nusBusStops = List<BusStop>.from(await BusAPI.getBusStops());
    for (int i = 0; i < _nusBusStops.length; i++) {
      double distanceBetweenCurrentAndBusStop = _coordinateDistance(
        _location[0].latitude,
        _location[0].longitude,
        _nusBusStops[i].latitude,
        _nusBusStops[i].longitude,
      );
      if (distanceSoFar > distanceBetweenCurrentAndBusStop) {
        distanceSoFar = distanceBetweenCurrentAndBusStop;
        nearestBusStop = _nusBusStops[i];
      }
    }
    return nearestBusStop;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addNUSBusStopsMarkers();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              markers: Set<Marker>.from(markers),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  width: width * 0.9,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width * 0.9,
                          child: TextField(
                            controller: startAddressController,
                            onChanged: (value) {},
                            decoration: new InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.map_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PlacePicker(
                                            apiKey:
                                                "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
                                            initialPosition: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                                            useCurrentLocation: false,
                                            selectInitialPosition: true,
                                            region: 'sg',
                                            onPlacePicked: (result) {
                                              selectedStartPlace = result;
                                              Navigator.of(context).pop();
                                              setState(() {
                                                startAddressController.text =
                                                    selectedStartPlace
                                                            .formattedAddress ??
                                                        "";
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                              labelText: 'Start',
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
                              hintText: 'Choose Starting Location',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: destinationAddressController,
                            onChanged: (value) {},
                            decoration: new InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.map_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PlacePicker(
                                            apiKey:
                                                "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
                                            initialPosition: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                                            region: 'sg',
                                            useCurrentLocation: false,
                                            selectInitialPosition: true,
                                            onPlacePicked: (result) {
                                              selectedDestinationPlace = result;
                                              Navigator.of(context).pop();
                                              setState(() {
                                                destinationAddressController
                                                        .text =
                                                    selectedDestinationPlace
                                                            .formattedAddress ??
                                                        "";
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                              labelText: 'Destination',
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
                              hintText: 'Choose Destination',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        selectedStartPlace == null ||
                                selectedDestinationPlace == null
                            ? Container()
                            : Container(
                                width: width * 0.3,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.grey[600]),
                                  ),
                                  child: Text(
                                    'Show Route',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    nearestToStart = await _findNearestBusStop(
                                      selectedStartPlace,
                                    );
                                    nearestToDestination =
                                        await _findNearestBusStop(
                                      selectedDestinationPlace,
                                    );
                                    print(nearestToStart);
                                    print(nearestToDestination);
                                    // dynamic result = await
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChooseRoute(
                                          nearestBusStopToStart: nearestToStart,
                                          nearestBusStopToDestination:
                                              nearestToDestination,
                                          startLocation: selectedStartPlace,
                                          destinationLocation:
                                              selectedDestinationPlace,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
