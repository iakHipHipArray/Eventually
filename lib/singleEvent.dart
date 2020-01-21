import 'package:EVENTually/dates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(
                          text: 'Summary',
                        ),
                        Tab(text: 'Activities'),
                        Tab(
                          text: 'Location',
                        ),
                        Tab(
                          text: 'Dates',
                        )
                      ],
                    ),
                    title: Text('My Event'),
                    ),
                body: TabBarView(
                  children: <Widget>[
                    Text('Summary'),
                    Text('Activities'),
                    Text('Location'),
                    DatesTab()
                  ],
                ))));
  }
}
