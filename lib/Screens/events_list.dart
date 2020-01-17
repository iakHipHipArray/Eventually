import 'package:EVENTually/Widgets/events_carousel.dart';
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

  Widget _buildHeader(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => print('Pressing the EVENTually Logo'),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 120.0),
                child: Text(
                  'EVENTually',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _headericons
                  .asMap()
                  .entries
                  .map(
                    (MapEntry map) => _buildIcon(map.key),
                  )
                  .toList(),
            ),
            SizedBox(height: 20.0),
          ],
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
    const imgindex = 1;
    return StreamBuilder<QuerySnapshot>(
      stream: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Events ${snapshot.data.documents}");
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Events List',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => print('Pressing the See All button'),
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
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _headericons
                    .asMap()
                    .entries
                    .map(
                      (MapEntry map) => _buildIcon(map.key),
                    )
                    .toList(),
              ),
              SizedBox(height: 20.0),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('All Events',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          )),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20.0),
              EventsCarousel(),
              SizedBox(height: 20.0),
              Container(
                height: 100.0,
                width: double.infinity,
                child: Text('Fixed Box'),
                color: Colors.pink,
              ),
              Expanded(
                child: ListView.builder(
                  itemExtent: 100.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                ),
              ),
            ],
          );
        }
        return CircularProgressIndicator();
      },
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

Widget _buildListItem(BuildContext context, data) {
  return Padding(
    key: ValueKey(data.data['eventName']),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
        child: Column(
      children: <Widget>[
        Text(data.data['eventName']),
        SizedBox(height: 10),
        Text(data.data['summary']),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            data.data['finalDate'] != null
                ? Text('Date: $data.finalDate')
                : Text('Date: TBC'),
            Spacer(),
            data.data['finalLocation'] != null
                ? Text('Location: $data.finalDate')
                : Text('Location: TBC')
          ],
        )
      ],
    )),
  );
}
