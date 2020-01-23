import 'package:EVENTually/router.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:EVENTually/delayed_animation.dart';

void main() {
  runApp(MyApp());
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
        primaryColor: Color(0xFFd32f2f),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('Home Page');
       final color = Theme.of(context).primaryColor;
    _scale = 1 - _controller.value;
    return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ 
              SizedBox(height: 32.0),
                DelayedAnimation(
                  child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
            image: AssetImage('assets/images/2020IAKEventually_Logo_AnimatedLarge.gif'),
            fit: BoxFit.cover,
          ),
        ),
                  delay: delayedAmount + 1500,
                ),
                SizedBox(height: 30.0),
                DelayedAnimation(
                  child: Container(
                   width: 320.0,
  height: 60.0,
  alignment: FractionalOffset.center,
  decoration: new BoxDecoration(
    color: const Color(0xFFD32F2F),
    borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
  ),
                  child: GestureDetector(
                    onTap: () {
                  Navigator.of(context)
                      .pushNamed(LoginPageRoute, arguments: 'Events List');
                  },
                                      child: Text(
                      'Welcome to EVENTually',
                      style: new TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.3,
    ),
                      ),
                  ),
                ),
                  delay: delayedAmount + 3000,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
