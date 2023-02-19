import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/utility/constants.dart';

class AppointmentService extends BaseService {
  List<AppointmentModel> _appointments = [];
  bool _isSearchingAll = false;
  bool _isSaving = false;

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/appointment/$id');
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      return AppointmentModel.fromJson(jsonDecode(resp.body));
    }
    return null;
  }

  @override
  Future<void> getAll({String? search}) async {
    _isSearchingAll = true;
    notifyListeners();
    Uri uri;
    if (search != null) {
      uri = Uri.http(Constants.baseApiUrl, '/appointments', {'search': search});
    } else {
      uri = Uri.http(Constants.baseApiUrl, '/appointments');
    }
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _appointments =
          respBody.map((e) => AppointmentModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<String?> save(AppointmentModel model) async {
    _isSaving = true;
    notifyListeners();
    final url = Uri.http(Constants.baseApiUrl, '/appointment');
    print(jsonEncode(model.toJson()));
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

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  bool get isSearchingAll => _isSearchingAll;
  bool get isSaving => _isSaving;
}
