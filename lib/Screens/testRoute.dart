import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      MyItemsPage.routeName: (BuildContext context) => new MyItemsPage(title: "MyItemsPage"),
    };
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TestHomePage(title: 'Flutter Demo Home Page'),
      routes: routes,
    );
  }
}

class TestHomePage extends StatefulWidget {
  TestHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TestHomePageState createState() => new _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {

  void _incrementCounter() {
    Navigator.pushNamed(context, MyItemsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var button = new IconButton(icon: new Icon(Icons.access_alarm), onPressed: _onButtonPressed);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new Text('Dog'),
          new Text('Cat'),
          button
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _onButtonPressed() {
    Navigator.pushNamed(context, MyItemsPage.routeName);
  }
}

class MyItemsPage extends StatefulWidget {
  MyItemsPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MyItemsPage";

  final String title;

  @override
  _MyItemsPageState createState() => new _MyItemsPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   MyItemsPage.routeName: (BuildContext context) => new MyItemsPage(title: "MyItemsPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, MyItemsPage.routeName);
///

class _MyItemsPageState extends State<MyItemsPage> {
  @override
  Widget build(BuildContext context) {
    var button = new IconButton(icon: new Icon(Icons.arrow_back), onPressed: _onButtonPressed);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Text('Item1'),
            new Text('Item2'),
            button
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {
  }

  void _onButtonPressed() {
    Navigator.pop(context);
  }
}
