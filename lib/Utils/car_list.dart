import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarDetailsPage.dart';

class CarListView extends StatefulWidget {
  final List cars;

  CarListView({@required this.cars});

  @override
  _CarListViewState createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  Widget build(context) {
    print("aaa ${widget.cars[0]['car_name']}");
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.cars == null ? 0 : widget.cars.length,
      itemBuilder: (context, i) {
        final _parentKey = GlobalKey();
        return Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CarsDetailPage(
                      car: widget.cars[i],
                      cars: widget.cars,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 275,
              width: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.cars[i]['car_name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "http://192.168.64.2/signaling/images/${widget.cars[i]['car_img_path']}",
                          height: 240,
                          width: 340,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("${widget.cars[i]['car_year']}"),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//  Widget createViewItem(Car car, BuildContext context) {
//    return new  Padding(
//      padding: EdgeInsets.only(right: 20),
//      child: GestureDetector(
//        onTap: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (BuildContext context) {
//                return CarsDetailPage(
//                  carId: int.parse(car.id),
//                );
//              },
//            ),
//          );
//        },
//        child: Container(
//          height: 275,
//          width: 280,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                car.name,
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 20,
//                ),
//              ),
//              SizedBox(height: 10),
//              ClipRRect(
//                borderRadius: BorderRadius.circular(15),
//                child:
//                Image.network(car.imageUrl,  height: 240,
//                  width: 280,
//                  fit: BoxFit.cover,
//                )
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

//Future is n object representing a delayed computation.
}
