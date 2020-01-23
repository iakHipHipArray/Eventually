import 'package:EVENTually/Pages/login.dart';
import 'package:EVENTually/Pages/profile.dart';
import 'package:EVENTually/Screens/events_list.dart';
import 'package:EVENTually/Screens/single_event.dart';
import 'package:EVENTually/main.dart';
import 'package:EVENTually/notifications.dart';
import 'package:EVENTually/routing_constants.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print('Router Args -> $args');
    switch (settings.name) {
      case HomePageRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case EventsPageRoute:
        return MaterialPageRoute(builder: (_) => EventsPage());
              case ProfilePageRoute:
        return MaterialPageRoute(builder: (_) => Profile());
              case NotificationsPageRoute:
        return MaterialPageRoute(builder: (_) => NotificationsPage());
      case LoginPageRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case SingleEventRoute:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SingleEvent(
              eventId: args,
            ),
          );
        }
        return errorRouteHandler(args);
      default:
        return errorRouteHandler(args);
    }
  }

  static MaterialPageRoute errorRouteHandler(Object args) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('404 Error'),
          ),
          body: Center(
            child: Text(
                'The argument provided is: $args - undefined route, please try again.'),
          ),
        );
      },
    );
  }
}
