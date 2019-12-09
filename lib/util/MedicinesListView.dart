import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Pages/MedicineDetailPage.dart';
import 'package:pharmacy/api/api.dart';

class MedicineListView extends StatefulWidget {

  final List list;

  MedicineListView({@required this.list});
  @override
  _MedicineListViewState createState() => _MedicineListViewState();
}

class _MedicineListViewState extends State<MedicineListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        print(i);
        return Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MedicineDetailPage(
                      medicine: int.parse(widget.list[i]),
                      medicines: widget.list,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 275,
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.list[i]['car_name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "${CallApi().url}/img/${widget.list[i]['car_img_path']}",
                      height: 240,
                      width: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
