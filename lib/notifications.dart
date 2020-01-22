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

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Notifications'),
          Expanded(
            child: ListView.builder(
              itemExtent: 80.0,
              itemCount: _notifications.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, _notifications[index]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, data) {
    return Card(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(data['body'])],
        ),
      ),
    );
  }
}
