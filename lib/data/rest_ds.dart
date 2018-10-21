import 'dart:async';

import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://YOUR_BACKEND_IP/login_app_backend";
  static final LOGIN_URL = BASE_URL + "/login.php";
  static final _API_KEY = "somerandomkey";

  Future<User> login(String email, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "email": email,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if (res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(res["user"]);
    });
  }
}
