import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            children: <Widget>[
              GestureDetector(
                onTap: () => print('Pressing the EVENTually Logo'),
                child: Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Text(
                    'EVENTually',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTab,
            onTap: (int value) {
              setState(() {
                _currentTab = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () => print('Pressing the events icon in the Navigation Bar'),
                                  child: Icon(
                    Icons.event,
                    size: 30.0,
                  ),
                ),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () => print('Pressing the friends icon in the Navigation Bar'),
                                  child: Icon(
                    Icons.people,
                    size: 30.0,
                  ),
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
            ]));
  }
}
