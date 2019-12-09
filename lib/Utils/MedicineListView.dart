import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Pages/MedicineDetailPage.dart';
import 'package:pharmacy/api/api.dart';

class MedicineListView extends StatefulWidget {
  final List medicine;

  MedicineListView({@required this.medicine});

  @override
  _MedicineListViewState createState() => _MedicineListViewState();
}

class _MedicineListViewState extends State<MedicineListView> {
  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.medicine == null ? 0 : widget.medicine.length,
      itemBuilder: (context, i) {
        final _parentKey = GlobalKey();
        return Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MedicineDetailPage(
                      medicine: widget.medicine[i],
                      medicines: widget.medicine,
                    );
                  },
                ),
              );
            },
            child: Card(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
              StringUtils.capitalize(widget.medicine[i]['name']),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "${widget.medicine[i]['imageUrl']}",
                          height: 240,
                          width: 340,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("${widget.medicine[i]['acqDate']}"),
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

}
