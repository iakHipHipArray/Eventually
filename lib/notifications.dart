import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List _notifications = [];
  List keys;
  var count = 0;
  GeoPoint _location;
  var _name;

  getDetails() {
    Firestore.instance
        .collection('users')
        .document('rmpillar')
        .get()
        .then((data) {
      _location = data.data['location'];
      _name = data.data['firstName'];
    });
  }

  getNotifications() {
    Firestore.instance
        .collection('notifications')
        .document('rmpillar')
        .get()
        .then((notifications) {
      setState(() {
        keys = notifications.data.keys.toList();
        for (var i = 0; i < keys.length; i++) {
          _notifications.add(notifications.data[keys[i]]);
        }
        count++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count < 1) getNotifications();
    getDetails();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('notifications')
            .document('rmpillar')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          final keys = snapshot.data.data.keys.toList();
          return ListView.builder(
              itemExtent: 80.0,
              itemCount: keys.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, _notifications[index]));
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, data) {
    return Card(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(data['body']),
            RaisedButton(
              child: Text('Accept'),
              onPressed: () {
                Firestore.instance
                    .collection('attendees')
                    .document(data['ID'])
                    .updateData({
                  data['username']: {
                    'attending': true,
                    'location': _location,
                    'ID': new DateTime.now().millisecondsSinceEpoch,
                    'name': _name
                  }
                });
                Firestore.instance
                    .collection('notifications')
                    .document('rmpillar')
                    .updateData({data['ID']: FieldValue.delete()});
              },
            )
          ],
        ),
      ),
    );
  }
}
