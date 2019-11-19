import 'dart:async';
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gocars/api/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:morpheus/morpheus.dart';

import 'CarDetailsPage.dart';

class CarDetailMapActivity extends StatefulWidget {
  final dynamic car;
  final double currlong;
  final double currlat;

  CarDetailMapActivity({this.car, this.currlong, this.currlat});

  @override
  State<CarDetailMapActivity> createState() => _CarDetailMapActivityState();
}

class _CarDetailMapActivityState extends State<CarDetailMapActivity> {
  double latitudeCurrent = 30.0271556;
  double longitudeCurrent = 31.0133856;
  Set<Marker> markers = Set();

  //Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyCJLNSD5zB42B-Ubd-Lr0LPQsrlVtQHCXo";

  BitmapDescriptor carIcon;

  void _getDeviceLocation() async {
    var location = new Location();
    location.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      distanceFilter: 0,
      interval: 100,
    );
    location.onLocationChanged().listen((LocationData currentLocation) {
      latitudeCurrent = currentLocation.latitude;
      longitudeCurrent = currentLocation.longitude;
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchControl = new TextEditingController();

  @override
  initState() {
    super.initState();
    latitudeCurrent = widget.currlat;
    longitudeCurrent = widget.currlong;
    polylines.clear();
    polylineCoordinates.clear();
    polylineCoordinates.clear();
    _getDeviceLocation();
    //By5aly sort el pin el a7mar tb2a sort el 3rbya el safra zy uber kda
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/car_icon.png')
        .then(
      (onValue) {
        carIcon = onValue;
      },
    );
    setState(
      () {
        //by fetch el 3rbyat mn database
        _getCarData();
      },
    );
  }

  _getCarData() async {
    setState(() {
      _getPolyline(double.parse(widget.car['car_lat']),
          double.parse(widget.car['car_long']));
      markers.add(
        Marker(
          icon: carIcon,
          markerId: MarkerId(widget.car['id'].toString()),
          infoWindow: InfoWindow(
              title: "${widget.car['car_name']} of id ${widget.car['id']}",
              snippet: "${widget.car['car_description']}"),
          position: LatLng(double.parse(widget.car['car_lat']),
              double.parse(widget.car['car_long'])),
        ),
      );
    });
    print("KILL ME");

    print("meaw");
//    markers.addAll([
//      Marker(
//          markerId: MarkerId('value'),
//          infoWindow: InfoWindow(title: "meaw"),
//          position: LatLng(30.0271555, 31.0133856)),
//      Marker(
//          markerId: MarkerId('value2'),
//          position: LatLng(30.0271556, 31.0133858)),
//    ]);
  }

  @override
  Widget build(BuildContext context) {

    void _currentLocation() async {
      final GoogleMapController controller = await _controller.future;
      LocationData currentLocation;
      var location = new Location();
      try {
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.0,
        ),
      ));
    }
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
//        child: FloatingActionButton.extended(
//          onPressed: _currentLocation,
//          label: Text('My Location'),
//          icon: Icon(Icons.location_on),
//        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitudeCurrent, longitudeCurrent),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _getDeviceLocation();
              _controller.complete(controller);
              _setStyle(controller);
              markers = Set();
              setState(() {
                _getCarData();
              });
            },
            polylines: Set<Polyline>.of(polylines.values),
            markers: markers,
            myLocationEnabled: true,

          ),

          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    StringUtils.capitalize(widget.car['car_name']),
                  ),
                  subtitle: Text("Click to see the car details"),
                  onTap: () {
                    polylines.clear();
                    polylineCoordinates.clear();
                    Navigator.of(context).pop();
                  },
                    trailing: Image.network(CallApi().url+"/img/"+widget.car['car_img_path'])
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  _addPolyLine() {
    setState(() {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
          polylineId: id, color: Colors.blue, points: polylineCoordinates);
      polylines[id] = polyline;
    });
  }

  _getPolyline(double destLat, double destLong) async {
    _getDeviceLocation();
    polylineCoordinates.clear();
    polylines.clear();

    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey, latitudeCurrent, longitudeCurrent, destLat, destLong);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
