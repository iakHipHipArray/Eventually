import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  int _selectedIndex = 0;

    List<IconData> _icons = []; // Placeholder for any additional EVENTually icons

  Widget _buildNavigationBarIcon(int index) {
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
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          _icons[index],
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
                  icon: Icon(
                    Icons.event,
                    size: 30.0,
                  ),
                // ),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon:  Icon(
                    Icons.people,
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
            ),
            );
  }
}
