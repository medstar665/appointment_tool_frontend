import 'dart:convert';

import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:http/http.dart' as http;

class ServiceService extends BaseService {
  late final UserManagement userManagement;
  List<ServiceModel> _services = [];
  bool _isSearchingAll = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  ServiceModel _viewService = ServiceModel();

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/facility/$id');
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      return ServiceModel.fromJson(jsonDecode(resp.body));
    }
    return null;
  }

  @override
  Future<void> getAll({String? search}) async {
    _isSearchingAll = true;
    notifyListeners();
    Uri uri;
    if (search != null) {
      uri = Uri.https(Constants.baseApiUrl, '/facilities', {'search': search});
    } else {
      uri = Uri.https(Constants.baseApiUrl, '/facilities');
    }
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _services = respBody.map((e) => ServiceModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<List<ServiceModel>> getAllServices({String? search}) async {
    Uri uri;
    if (search != null) {
      uri = Uri.https(Constants.baseApiUrl, '/facilities', {'search': search});
    } else {
      uri = Uri.https(Constants.baseApiUrl, '/facilities');
    }
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      final serviceTitles =
          respBody.map((e) => ServiceModel.fromJson(e)).toList();
      return serviceTitles;
    }
    return [];
  }

  Future<String?> add(ServiceModel model) async {
    _isAdding = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/facility');
    http.Response resp = await http.post(url,
        body: jsonEncode(model.toJson()), headers: _getHeader());
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isAdding = false;
    notifyListeners();
    return error;
  }

  Future<String?> update(ServiceModel model) async {
    _isUpdating = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/facility');
    http.Response resp = await http.put(url,
        body: jsonEncode(model.toJson()), headers: _getHeader());
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isUpdating = false;
    notifyListeners();
    return error;
  }

  void setViewService(ServiceModel service) {
    _viewService = service;
  }

  Map<String, String> _getHeader() {
    return Constants.requestHeader
      ..addAll({"authorization": UserManagement.token ?? ''});
  }

  List<ServiceModel> get services => List.unmodifiable(_services);
  @override
  bool get isSearchingAll => _isSearchingAll;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  ServiceModel get viewService => _viewService;
}
