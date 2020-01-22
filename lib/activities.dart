import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  newActivity(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Suggest Activity'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Activity"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: "Description"),
            ),
            FlatButton(
                child: new Text('SUGGEST'),
                onPressed: () {
                  final now = (new DateTime.now()).millisecondsSinceEpoch.toString();
                  final activity = {now:{'name':_nameController.text,'body':_descriptionController.text,'votes':0}};
                  print(activity);
                  Firestore.instance.collection('activities').document('event1').updateData(activity);
                   Navigator.of(context).pop();
                },)
              ],
            ),
            
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
    Expanded(
      child: _buildBody(context),
    ),
    RaisedButton(
      child: Icon(
        Icons.add,
        semanticLabel: 'SUggest a new activity',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        newActivity(context);
      }
    )
      ],
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('activities')
        .document('event1')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Text('LOADING');
      var keys = snapshot.data.data.keys.toList();
      return ListView.builder(
          itemExtent: 80.0,
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final activity= snapshot.data.data[keys[index]]['name'].toString();
            final description = snapshot.data.data[keys[index]]['body'].toString();
            return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(activity),
                    Text(description)
                  ],
                ),
            );
          },
      );
    },
  );
}

