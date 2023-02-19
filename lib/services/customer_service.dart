import 'dart:convert';

import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:http/http.dart' as http;

class CustomerService extends BaseService {
  List<CustomerModel> _customers = [];
  bool _isSearchingAll = false;
  bool _isSaving = false;

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/customer/$id');
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      return CustomerModel.fromJson(jsonDecode(resp.body));
    }
    return null;
  }

  @override
  Future<void> getAll({String? search}) async {
    _isSearchingAll = true;
    notifyListeners();
    Uri uri;
    if (search != null && search.isNotEmpty) {
      uri = Uri.http(Constants.baseApiUrl, '/customers', {'search': search});
    } else {
      uri = Uri.http(Constants.baseApiUrl, '/customers');
    }
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _customers = respBody.map((e) => CustomerModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<String?> save(CustomerModel customer) async {
    _isSaving = true;
    notifyListeners();
    final url = Uri.http(Constants.baseApiUrl, '/customer');
    http.Response resp = await http.post(url,
        body: jsonEncode(customer.toJson()), headers: Constants.requestHeader);
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isSaving = false;
    notifyListeners();
    return error;
  }

  Future<List<CustomerModel>> getCustomerNames({String? search}) async {
    Uri uri;
    if (search != null && search.isNotEmpty) {
      uri =
          Uri.http(Constants.baseApiUrl, '/customer/names', {'search': search});
    } else {
      uri = Uri.http(Constants.baseApiUrl, '/customer/names');
    }
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      List<CustomerModel> customernames =
          respBody.map((e) => CustomerModel.fromJson(e)).toList();
      return customernames;
    }
    return [];
  }

  List<CustomerModel> get customers => List.unmodifiable(_customers);
  bool get isSearchingAll => _isSearchingAll;
  bool get isSaving => _isSaving;
}
