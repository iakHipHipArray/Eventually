import 'package:EVENTually/router.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePageRoute,
      onGenerateRoute: Router.generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'EVENTually',
       theme: ThemeData(
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('press me'),
              onPressed: () {
                Navigator.of(context).pushNamed(EventsPageRoute, arguments: 'Events List');
              },
            ),
          ],
        ),
        ),
        );
  }
}

