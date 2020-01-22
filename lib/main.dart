import 'package:EVENTually/router.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Home Page');
    return Scaffold(
        appBar: AppBar(title: Text('EVENTually')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('press me'),
              onPressed: () {
                Navigator.of(context).pushNamed(LoginPageRoute, arguments: 'Events List');
              },
            ),
          ],
        ),
        ),
        );
  }
}

