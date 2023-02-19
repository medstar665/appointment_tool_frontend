import 'dart:convert';

import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:http/http.dart' as http;

class ServiceService extends BaseService {
  List<ServiceModel> _services = [];
  bool _isSearchingAll = false;
  bool _isSaving = false;

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/facility/$id');
    http.Response resp = await http.get(uri);
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
      uri = Uri.http(Constants.baseApiUrl, '/facilities', {'search': search});
    } else {
      uri = Uri.http(Constants.baseApiUrl, '/facilities');
    }
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _services = respBody.map((e) => ServiceModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<List<ServiceModel>> getAllTitles({String? search}) async {
    Uri uri;
    if (search != null) {
      uri = Uri.http(
          Constants.baseApiUrl, '/facility/titles', {'search': search});
    } else {
      uri = Uri.http(Constants.baseApiUrl, '/facility/titles');
    }
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      final serviceTitles =
          respBody.map((e) => ServiceModel.fromJson(e)).toList();
      return serviceTitles;
    }
    return [];
  }

  Future<String?> save(ServiceModel model) async {
    _isSaving = true;
    notifyListeners();
    final url = Uri.http(Constants.baseApiUrl, '/facility');
    http.Response resp = await http.post(url,
        body: jsonEncode(model.toJson()), headers: Constants.requestHeader);
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isSaving = false;
    notifyListeners();
    return error;
  }

  List<ServiceModel> get services => List.unmodifiable(_services);

  bool get isSearchingAll => _isSearchingAll;
  bool get isSaving => _isSaving;
}
