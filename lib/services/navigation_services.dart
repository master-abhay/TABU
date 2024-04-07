import 'package:firestore_tutorial/ui/home_Page.dart';
import 'package:firestore_tutorial/ui/login_page.dart';
import 'package:firestore_tutorial/ui/register_page.dart';
import 'package:flutter/material.dart';

class NavigationServices {
  late GlobalKey<NavigatorState> _navigatorStateKey;
  Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    "/home": (context) => HomePage(),
    "/register": (context) => RegisterPage(),
  };

  GlobalKey<NavigatorState> get navigatorStateKey {
    return _navigatorStateKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationServices() {
    _navigatorStateKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) {
    _navigatorStateKey.currentState!.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorStateKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorStateKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorStateKey.currentState?.pop();
  }
}
