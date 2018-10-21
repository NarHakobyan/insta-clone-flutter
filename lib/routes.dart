import 'package:flutter/material.dart';
import 'package:insta_clone/screens/home.dart';
import 'package:insta_clone/screens/login/login_screen.dart';

class RouteUrls {
  static const String Home = '/';
  static const String Login = '/login';
}

final routes = {
  RouteUrls.Home: (BuildContext context) => HomeScreen(title: "hello"),
  RouteUrls.Login: (BuildContext context) => LoginScreen()
};
