import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medstar_appointment/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagement extends ChangeNotifier {
  static String? token;
  SharedPreferences? _sharedPreferences;
  bool _loggedIn = false;
  String? name;
  final String AUTH_TOKEN_KEY = 'auth_token';
  final String EXPIRY_TOKEN_KEY = 'token_expiry_time';
  final String USER_NAME = 'user_name';

  UserManagement() {
    _initCheck();
  }

  Future<void> _initCheck() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    UserManagement.token = _sharedPreferences!.getString(AUTH_TOKEN_KEY);
    if (UserManagement.token != null) {
      DateTime loginTime =
          DateTime.parse(_sharedPreferences!.getString(EXPIRY_TOKEN_KEY)!);
      if (DateTime.now().isAfter(loginTime)) {
        _sharedPreferences!.clear();
      } else {
        UserManagement.token = UserManagement.token;
        name = _sharedPreferences!.getString(USER_NAME);
        _loggedIn = true;
      }
    }
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    Uri uri = Uri.https(Constants.baseApiUrl, 'login', {
      'email': email,
      'password': password,
    });
    DateTime loginTime = DateTime.now();
    http.Response resp = await http.post(uri, headers: Constants.requestHeader);
    final loginInfo = resp.body.split(',');
    loginTime =
        loginTime.add(Duration(minutes: int.tryParse(loginInfo[1]) ?? 60));
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
      _loggedIn = false;
    } else {
      _setSharedPref(loginInfo[0], loginTime.toIso8601String(), loginInfo[2]);
      _loggedIn = true;
    }
    notifyListeners();
    return error;
  }

  Future<String?> logout() async {
    Uri uri = Uri.https(Constants.baseApiUrl, 'logout');
    http.Response resp = await http.post(uri,
        headers: Constants.requestHeader
          ..addAll({"authtoken": UserManagement.token ?? ''}));
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
      _loggedIn = true;
    } else {
      _sharedPreferences!.clear();
      UserManagement.token = name = null;
      _loggedIn = false;
    }
    notifyListeners();
    return error;
  }

  void _setSharedPref(String token, String expiryTime, String name) {
    this.name = name;
    UserManagement.token = token;

    _sharedPreferences!.setString(AUTH_TOKEN_KEY, token);
    _sharedPreferences!.setString(EXPIRY_TOKEN_KEY, expiryTime);
    _sharedPreferences!.setString(USER_NAME, name);
  }

  bool get isLoggedIn => _loggedIn;
}
