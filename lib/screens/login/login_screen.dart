import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:insta_clone/auth.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/screens/login/login_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password;

  LoginScreenPresenter _presenter;

  String loginMutation = """
mutation Login(\$email: String!, \$password: String!) {
  login(email: \$email, password: \$password) {
    user {
      firstName
    }
    token
  }
}
"""
      .replaceAll('\n', ' ');

  void initState() {
    super.initState();

    this.getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('token ${prefs.getString('token')}');
  }

  _LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  EdgeInsets inputEdgeInsets() =>
      EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0);

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = Mutation(loginMutation, builder: (
      runMutation, {
      bool loading,
      var data,
      Exception error,
    }) {
      if (loading) {
        return CircularProgressIndicator();
      }
      if (error != null && error is GQLException) {
        print(error.gqlErrors);
      }
      return RaisedButton(
        onPressed: () {
          final form = formKey.currentState;

          if (form.validate()) {
            setState(() => _isLoading = true);
            form.save();
            runMutation({'email': _email, 'password': _password});
          }
        },
        child: Text("LOGIN"),
        color: Theme.of(_ctx).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        textColor: Theme.of(_ctx).textTheme.button.color,
      );
    }, onCompleted: (Map<String, dynamic> data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['login']['token']);
    });
    var forgotPasswordBtn = FlatButton(
      onPressed: _forgotPassword,
      child: Text("forgot password"),
      textColor: Theme.of(_ctx).primaryColor,
    );

    var loginForm = Column(
      children: <Widget>[
        Padding(
          child: Image.asset('assets/images/logo.png'),
          padding: EdgeInsets.only(bottom: 60.0),
        ),
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: inputEdgeInsets(),
                child: TextFormField(
                  autovalidate: true,
                  onSaved: (val) => _email = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Email must have atleast 10 chars"
                        : null;
                  },
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: inputEdgeInsets(),
                child: TextFormField(
                  obscureText: true,
                  autovalidate: true,
                  onSaved: (val) => _password = val,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ),
              Padding(
                padding: inputEdgeInsets(),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[loginBtn, forgotPasswordBtn],
                ),
              )
            ],
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
    return Scaffold(
        backgroundColor: Theme.of(_ctx).backgroundColor,
        body: Center(
          child: loginForm,
        ));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    print(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  void _forgotPassword() {
    print('forgotPassword clicked');
  }
}
