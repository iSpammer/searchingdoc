import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:morpheus/morpheus.dart';

import 'CarDetailsPage.dart';

class CarDetailMapActivity extends StatefulWidget {
  final dynamic car;

  CarDetailMapActivity({this.car});

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
    //print("reemo $response");
     setState(() {
       _getPolyline(double.parse(widget.car['car_lat']), double.parse(widget.car['car_long']));
       markers.add(
          Marker(
            icon: carIcon,
            markerId: MarkerId(widget.car['id'].toString()),
            infoWindow: InfoWindow(
                title: "${widget.car['car_name']} of id ${widget.car['id']}",
                snippet: "${widget.car['car_description']}"),
            position: LatLng(
                double.parse(widget.car['car_lat']), double.parse(widget.car['car_long'])),

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Column(
            children: <Widget>[
              Card(
                elevation: 6.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.square(16.0),
          child: Container(),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitudeCurrent, longitudeCurrent),
          zoom: 5,
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
    );
  }

  _addPolyLine()
  {
    setState(() {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blue, points: polylineCoordinates
      );
      polylines[id] = polyline;
    });
  }

  _getPolyline(double destLat, double destLong)async
  {
    _getDeviceLocation();
    polylines.clear();
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(googleAPiKey,
        latitudeCurrent, longitudeCurrent, destLat, destLong);
    if(result.isNotEmpty){
      result.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}

