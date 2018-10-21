import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:insta_clone/data/rest_ds.dart';
import 'package:insta_clone/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String email, String password) {
    // api.login(username, password).then((User user) {
    //   _view.onLoginSuccess(user);
    // }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
