import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gocars/api/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:morpheus/morpheus.dart';

import 'CarDetailsPage.dart';

class MapsActivity extends StatefulWidget {
  final LatLng latLng;

  MapsActivity({this.latLng});

  @override
  State<MapsActivity> createState() => _MapsActivityState();
}

class _MapsActivityState extends State<MapsActivity> {
  double latitudeCurrent = 30.0271556;
  double longitudeCurrent = 31.0133856;
  Set<Marker> markers = Set();

  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 30.0271556, _destLongitude = 31.0133856;
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

    //By5aly sort el pin el a7mar tb2a sort el 3rbya el safra zy uber kda
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'images/car_icon.png')
        .then(
          (onValue) {
        carIcon = onValue;
      },
    );

//    Marker _marker = new Marker(
//      icon: BitmapDescriptor.defaultMarker,
//      markerId: MarkerId("12"),
//      position: LatLng(30.0271556,31.0133856),
//      infoWindow: InfoWindow(title: "userMarker", snippet: '*'),
//    );
//    markers.add(_marker);
    setState(
          () {
            //by fetch el 3rbyat mn database
        _getCarsData();
      },
    );
    if(widget.latLng != null){

    }
  }

  _getCarsData() async {
    Dio http = new Dio();
    final response =
    await http.get("${CallApi().url}/cars");
    //print("reemo $response");

    var cars = json.decode(response.data.toString());
    for (var car in cars) {
      setState(() {
        markers.add(
          Marker(
            icon: carIcon,
            markerId: MarkerId(car['id'].toString()),
            infoWindow: InfoWindow(
                title: "${car['car_name']} of id ${car['id']}",
                snippet: "${car['car_description']}"),
            position: LatLng(
                double.parse(car['car_lat']), double.parse(car['car_long'])),
            onTap: () {
              polylineCoordinates.clear();
              polylines.clear();
              _getPolyline(double.parse(car['car_lat']), double.parse(car['car_long']));
              print("meaw");
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) {
                    return CarsDetailPage(
                      car: car,
                      cars: cars,
                    );
                  },
                ),
              );
            },
          ),
        );
      });
      print("KILL ME");

    }
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
                elevation: 5.0,
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
          child: SizedBox(),
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
            _getCarsData();
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

