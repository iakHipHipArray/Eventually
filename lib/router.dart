import 'package:EVENTually/Screens/events_list.dart';
import 'package:EVENTually/Screens/single_event.dart';
import 'package:EVENTually/main.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomePageRoute: 
        return MaterialPageRoute(builder: (_) => MyHomePage(title: 'EVENTually'));
      case EventsPageRoute:
        return MaterialPageRoute(builder: (_) => EventsPage());
      case SingleEventRoute:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SingleEvent(
              eventId: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}
