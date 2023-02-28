import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentStatus {
  static const String Booked = 'Booked';
  static const String Completed = 'Completed';
  static const String No_Show = 'No-Show';
  static const String Cancelled = 'Cancelled';
}

class AppointmentService extends BaseService {
  List<AppointmentModel> _appointments = [];
  bool _isSearchingAll = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _updatingStatus = false;
  AppointmentModel _viewAppointment =
      AppointmentModel(customerId: 0, serviceId: 0);

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/appointment/$id');
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      return AppointmentModel.fromJson(jsonDecode(resp.body));
    }
    return null;
  }

  @override
  Future<void> getAll(
      {String? search, DateTime? startDate, DateTime? endDate}) async {
    _isSearchingAll = true;
    notifyListeners();
    Uri uri = Uri.https(Constants.baseApiUrl, '/appointments', {
      'search': search,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    });
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _appointments =
          respBody.map((e) => AppointmentModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<void> downloadReport(
      {String? search, DateTime? startDate, DateTime? endDate}) async {
    Uri uri = Uri.https(Constants.baseApiUrl, '/appointments-download', {
      'search': search,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    });
    await launchUrl(uri);
  }

  Future<String?> add(AppointmentModel model) async {
    _isAdding = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/appointment');
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

  Future<String?> update(AppointmentModel model) async {
    _isUpdating = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/appointment');
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

  Future<String?> updateStatus(int id, String toStatus) async {
    _updatingStatus = true;
    notifyListeners();
    String path = '/appointment/$id';
    if (toStatus == AppointmentStatus.Cancelled) {
      path += '/cancel';
    } else if (toStatus == AppointmentStatus.No_Show) {
      path += '/no-show';
    } else if (toStatus == AppointmentStatus.Completed) {
      path += '/complete';
    }
    Uri uri = Uri.https(Constants.baseApiUrl, path);
    http.Response resp = await http.put(uri, headers: _getHeader());
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _updatingStatus = false;
    return error;
  }

  Future<List<AppointmentModel>> getAppointmentBetween(
      DateTime start, DateTime end) async {
    Uri uri = Uri.https(Constants.baseApiUrl, '/appointments', {
      'startDate': start.toIso8601String(),
      'endDate': end.toIso8601String()
    });
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      return respBody.map((e) => AppointmentModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  void setViewAppointment(AppointmentModel appointment) {
    _viewAppointment = appointment;
    notifyListeners();
  }

  Map<String, String> _getHeader() {
    return Constants.requestHeader
      ..addAll({"authtoken": UserManagement.token ?? ''});
  }

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  @override
  bool get isSearchingAll => _isSearchingAll;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get updatingStatus => _updatingStatus;
  AppointmentModel get viewAppointment => _viewAppointment;
}
