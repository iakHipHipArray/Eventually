import 'package:EVENTually/Models/events_model.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsPage extends StatefulWidget {
  EventsPage({Key key, this.eventId}) : super(key: key);
  final String eventId;

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
              : Color(0xFF263238),
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
          final eventsData = snapshot.data.documents[index].data;
          Events event = events[index];
          return eventCarouselInnerContainer(eventsData, context, event);
        },
      ),
    );
  }

  Container eventCarouselInnerContainer(
      Map<String, dynamic> eventsData, BuildContext context, Events event) {
    // print('in events_list -> ${eventsData['ID']}');
    return Container(
      margin: EdgeInsets.all(10.0),
      width: 210.0,
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(SingleEventRoute, arguments: '${eventsData['ID']}'),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              bottom: -0.0,
              child: eventCarouselTextBackground(eventsData, context),
            ),
            eventCarouselImageShadow(event),
          ],
        ),
      ),
    );
  }

  Container eventCarouselTextBackground(
      Map<String, dynamic> eventsData, BuildContext context) {
    return Container(
      height: 120.0,
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: eventCarouselTextOverlay(eventsData, context),
    );
  }

  Padding eventCarouselTextOverlay(
      Map<String, dynamic> eventsData, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          eventCarouselEventName(eventsData, context),
          eventCarouselEventSummary(eventsData),
        ],
      ),
    );
  }

  Text eventCarouselEventName(
      Map<String, dynamic> eventsData, BuildContext context) {
    return Text(
      eventsData['eventName'],
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Text eventCarouselEventSummary(Map<String, dynamic> eventsData) {
    return Text(
      eventsData['summary'],
      style: TextStyle(
        color: Colors.grey,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Container eventCarouselImageShadow(Events event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: eventCarouselImage(event),
    );
  }

  Stack eventCarouselImage(Events event) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
            height: 180.0,
            width: 180.0,
            image: AssetImage(event.image),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Padding mainHeader() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(
          image: AssetImage(
              'assets/images/2020IAKEventually_Logo_AnimatedLarge.gif'),
          width: 100,
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
          icon: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(CreateEventRoute),
                      child: Icon(
              Icons.add_comment,
              size: 30.0,
            ),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(NotificationsPageRoute),
            child: Icon(
              Icons.notifications_active,
              size: 30.0,
            ),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(ProfilePageRoute),
            child: CircleAvatar(
              radius: 15.0,
              backgroundImage: NetworkImage(
                  'https://image.shutterstock.com/image-vector/default-avatar-profile-icon-grey-260nw-1545688190.jpg'),
            ),
          ),
          title: SizedBox.shrink(),
        ),
      ],
    );
  }
}
