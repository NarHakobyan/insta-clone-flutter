import 'package:flutter/material.dart';
import 'package:insta_clone/routes.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token;

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != '') {
      setState(() {
        _token = token;
      });
    }
  }
  @override
    void initState() {
      super.initState();
      getToken();
    }

  @override
  Widget build(BuildContext context) {
    print("app start $_token");
    return GraphqlProvider(
      client: ValueNotifier(
        Client(
          apiToken: _token,
          endPoint: 'http://localhost:4000/graphql',
          cache: InMemoryCache(),
        ),
      ),
      child: MaterialApp(
        title: 'Insta clone app',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF7fca8f),
            backgroundColor: Colors.white,
            textTheme: TextTheme(button: TextStyle(color: Colors.white))),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
