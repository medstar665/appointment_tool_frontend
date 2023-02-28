import 'package:http/http.dart' as http;
import 'package:medstar_appointment/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagement {
  static SharedPreferences? _sharedPreferences;
  bool loggedIn = false;
  static String? token;
  static String? name;
  final String AUTH_TOKEN_KEY = 'auth_token';
  final String EXPIRY_TOKEN_KEY = 'token_expiry_time';
  final String USER_NAME = 'user_name';

  UserManagement._create() {}

  static Future<UserManagement> create() async {
    final UserManagement um = UserManagement._create();
    await um._initCheck();
    return um;
  }

  Future<void> _initCheck() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    token = _sharedPreferences!.getString(AUTH_TOKEN_KEY);
    if (token != null) {
      DateTime loginTime =
          DateTime.parse(_sharedPreferences!.getString(EXPIRY_TOKEN_KEY)!);
      if (DateTime.now().isAfter(loginTime)) {
        _sharedPreferences!.clear();
      } else {
        UserManagement.token = token;
        UserManagement.name = _sharedPreferences!.getString(USER_NAME);
        loggedIn = true;
      }
    }
  }

  Future<String?> login(String email, String password) async {
    Uri uri = Uri.https(Constants.baseApiUrl, 'login', {
      'email': email,
      'password': password,
    });
    DateTime loginTime = DateTime.now();
    http.Response resp = await http.post(uri, headers: Constants.requestHeader);
    final loginInfo = resp.body.split(',');
    loginTime.add(Duration(minutes: int.tryParse(loginInfo[1]) ?? 60));
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
      loggedIn = false;
    } else {
      _setSharedPref(loginInfo[0], loginTime.toIso8601String(), loginInfo[2]);
      loggedIn = true;
    }
    return error;
  }

  Future<String?> logout() async {
    Uri uri = Uri.https(Constants.baseApiUrl, 'logout');
    http.Response resp = await http.post(uri,
        headers: Constants.requestHeader
          ..addAll({"authorization": token ?? ''}));
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
      loggedIn = true;
    } else {
      _sharedPreferences!.clear();
      UserManagement.token = UserManagement.name = null;
      loggedIn = false;
    }
    return error;
  }

  void _setSharedPref(String token, String expiryTime, String name) {
    UserManagement.name = name;
    UserManagement.token = token;

    _sharedPreferences!.setString(AUTH_TOKEN_KEY, token);
    _sharedPreferences!.setString(EXPIRY_TOKEN_KEY, expiryTime);
    _sharedPreferences!.setString(USER_NAME, name);
  }
}
