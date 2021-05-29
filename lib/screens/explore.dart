import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:nusnav/keys.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  GoogleMapController mapController;
  PickResult selectedStartPlace;
  PickResult selectedDestinationPlace;

  final LatLng _center = const LatLng(1.2966, 103.7764);

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Position _currentPosition;

  // _getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) async {
  //     setState(() {
  //       _currentPosition = position;

  //       print('CURRENT POS: $_currentPosition');

  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(position.latitude, position.longitude),
  //             zoom: 18.0,
  //           ),
  //         ),
  //       );
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

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
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                            apiKey: "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
                                            initialPosition: _center,
                                            useCurrentLocation: false,
                                            selectInitialPosition: true,
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
                                            initialPosition: _center,
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
