import 'package:flutter/material.dart';
import 'package:EVENTually/maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Location extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    return Container(
      child: _getData(context)
    );
  }
}


Widget _getData(BuildContext context){

  return StreamBuilder(
      stream: Firestore.instance
          .collection('attendees')
          .document('event1')
          .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('...Loading');
        return StreamBuilder(
          stream: Firestore.instance
          .collection('locations')
          .document('event1')
          .snapshots(),
          
          builder: (context ,snapshot) {
            final data = snapshot.data.data;
            final keys = data.keys.toList();
            print(context);
          },

        );
      }
  );
}
