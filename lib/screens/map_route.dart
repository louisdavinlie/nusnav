import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nusnav/models/bus_stop.dart';

import 'components/custom_appbar.dart';

class MapRoute extends StatefulWidget {
  final LatLng startLocationCoordinates;
  final LatLng destinationLocationCoordinates;
  final List<BusStop> visitedBusStops;
  final Widget routeDisplay;

  const MapRoute({
    Key key,
    @required this.startLocationCoordinates,
    @required this.destinationLocationCoordinates,
    @required this.visitedBusStops,
    @required this.routeDisplay,
  }) : super(key: key);

  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  GoogleMapController mapController;

  // Object for PolylinePoints
  PolylinePoints polylinePoints;

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  Set<Marker> markers = {};
  List<LatLng> latLngList = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  _addStartAndDestinationMarkers(
    LatLng startLocation,
    LatLng destinationLocation,
  ) {
    setState(() {
      double startLatitude = startLocation.latitude;
      double startLongitude = startLocation.longitude;
      double destinationLatitude = destinationLocation.latitude;
      double destinationLongitude = destinationLocation.longitude;
      Marker startMarker = Marker(
        markerId: MarkerId('($startLatitude, $startLongitude)'),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      Marker destinationMarker = Marker(
        markerId: MarkerId('($destinationLatitude, $destinationLongitude)'),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers.add(startMarker);
      markers.add(destinationMarker);
    });
  }

  // _getLatLngList() async {
  //   List<BusStop> _nusBusStops = List<BusStop>.from(await BusAPI.getBusStops());
  //   setState(() {
  //     latLngList = List<LatLng>.from(_nusBusStops
  //         .map((busStop) => LatLng(busStop.latitude, busStop.longitude)));
  //   });
  // }

  _createPolylines(LatLng startLocation, LatLng destinationLocation,
      List<BusStop> visitedBusStops) async {
    // List of coordinates to join
    List<LatLng> _polylineCoordinates = [];

    // Map storing polylines created by connecting two points
    Map<PolylineId, Polyline> _polylines = {};

    polylinePoints = PolylinePoints();

    // PolylineResult startToFirstBusStop =
    //     await polylinePoints.getRouteBetweenCoordinates(
    //   "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
    //   PointLatLng(
    //     startLocation.latitude,
    //     startLocation.longitude,
    //   ),
    //   PointLatLng(
    //     visitedBusStops[0].latitude,
    //     visitedBusStops[0].longitude,
    //   ),
    //   travelMode: TravelMode.walking,
    // );

    // if (startToFirstBusStop.points.isNotEmpty) {
    //   startToFirstBusStop.points.forEach((PointLatLng point) {
    //     _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
    _polylineCoordinates.add(startLocation);

    for (int i = 0; i < visitedBusStops.length - 1; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
        PointLatLng(
          visitedBusStops[i].latitude,
          visitedBusStops[i].longitude,
        ),
        PointLatLng(
          visitedBusStops[i + 1].latitude,
          visitedBusStops[i + 1].longitude,
        ),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    // PolylineResult lastBusStopToDestination =
    //     await polylinePoints.getRouteBetweenCoordinates(
    //   "AIzaSyCABm1zDzY-BvdqL7q1vcV7u-wdzbzQbtY",
    //   PointLatLng(
    //     visitedBusStops[visitedBusStops.length - 1].latitude,
    //     visitedBusStops[visitedBusStops.length - 1].longitude,
    //   ),
    //   PointLatLng(
    //     destinationLocation.latitude,
    //     destinationLocation.longitude,
    //   ),
    //   travelMode: TravelMode.walking,
    // );

    // if (lastBusStopToDestination.points.isNotEmpty) {
    //   lastBusStopToDestination.points.forEach((PointLatLng point) {
    //     _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }

    _polylineCoordinates.add(destinationLocation);

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: _polylineCoordinates,
      width: 3,
    );
    _polylines[id] = polyline;
    setState(() {
      polylines = Map<PolylineId, Polyline>.from(_polylines);
      polylineCoordinates = List<LatLng>.from(_polylineCoordinates);
    });
  }

  @override
  void initState() {
    super.initState();
    _addBusStopMarkers(widget.visitedBusStops);
    _addStartAndDestinationMarkers(
      widget.startLocationCoordinates,
      widget.destinationLocationCoordinates,
    );
    _createPolylines(
      widget.startLocationCoordinates,
      widget.destinationLocationCoordinates,
      widget.visitedBusStops,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        appBar: CustomAppBar(
          autoImplyLeading: true,
          extraAppBarHeight: 0,
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.from(markers),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.startLocationCoordinates,
                zoom: 18.0,
              ),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Container(
              color: Colors.grey[300],
              child: ExpansionTile(
                title: Text('Show Route'),
                children: [
                  widget.routeDisplay,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
