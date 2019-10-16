import 'package:flutter/material.dart';
import 'package:gocars/util/data.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        physics: ScrollPhysics(), // this is what you are looking for
        primary: false,
        shrinkWrap: true,
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          Map transaction = history[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  transaction['dp'],
                ),
                radius: 25,
              ),
              title: Text(transaction['name']),
              subtitle: Text(transaction['date']),
              trailing: Text(
                transaction['type'] == "sent"
                    ? "-${transaction['amount']}"
                    : "+${transaction['amount']}",
                style: TextStyle(
                  color:
                      transaction['type'] == "sent" ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
