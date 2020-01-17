import 'package:EVENTually/Models/events_model.dart';
//import 'package:EVENTually/Widgets/events_carousel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {
  int _currentTab = 0;
  int _selectedIndex = 0;

  List<IconData> _headericons = [
    FontAwesomeIcons.stickyNote,
    FontAwesomeIcons.chess,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.globe,
  ];

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        print(_selectedIndex);
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Theme.of(context).accentColor
              : Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          _headericons[index],
          size: 25.0,
          color: _selectedIndex == index
              ? Theme.of(context).primaryColor
              : Color(0xFFf4b9b2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.home),
      ),
      body: _buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  getEvents() {
    return Firestore.instance
        .collection('events')
        .where('attendees', arrayContains: 'ryan1214')
        .snapshots();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                children: <Widget>[
                  mainHeader(),
                  headerNavigationBar(),
                  subHeaderRow(context),
                  eventCarousel(snapshot),
                ],
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Container eventCarousel(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      height: 300.0,
      color: Colors.blue,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
          final eventsData = snapshot.data.documents[index].data;
       //  print(eventsData);
          return eventItem(eventsData);
        },
      ),
    );
  }

  Container eventItem(Map<String, dynamic> eventsData) {
    return Container(
          margin: EdgeInsets.all(10.0),
          width: 210.0,
          color: Colors.red,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                width: 210.0,
                color: Colors.red,
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: 120.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(eventsData['eventName'],
                            style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                            ),
                            Text(eventsData['summary'],
                            ),
                            ],
                        ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  Padding mainHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 120.0, bottom: 20.0),
      child: Text(
        'Events List',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row subHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          child: Text(
            'Your Events',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => print('Pressing the See All Button'),
          child: Text(
            'See All',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Row headerNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _headericons
          .asMap()
          .entries
          .map((MapEntry map) => _buildIcon(map.key))
          .toList(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTab,
      onTap: (int value) {
        setState(() {
          _currentTab = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 30.0,
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.local_cafe,
            size: 30.0,
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(
                'https://image.shutterstock.com/image-vector/default-avatar-profile-icon-grey-260nw-1545688190.jpg'),
          ),
          title: SizedBox.shrink(),
        ),
      ],
    );
  }
}
