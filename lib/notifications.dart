import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List _notifications;

  getNotifications() {
    Firestore.instance
        .collection('notifications')
        .document('rmpillar')
        .get()
        .then((notifications) => {
              setState(() {
                print(notifications);
                _notifications = ['hello'];
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    getNotifications();
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemExtent: 80.0,
            itemCount: _notifications.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, _notifications[index]),
          ),
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, data) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(data['body'])],
      ),
    );
  }
}
