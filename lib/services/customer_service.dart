import 'dart:convert';

import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:http/http.dart' as http;

class CustomerService extends BaseService {
  List<CustomerModel> _customers = [];
  bool _isSearchingAll = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  CustomerModel _viewCustomer = CustomerModel();

  @override
  Future get({required int id}) async {
    final uri = Uri.http('${Constants.baseApiUrl}/customer/$id');
    http.Response resp = await http.get(uri, headers: _getHeader());
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
      uri = Uri.https(Constants.baseApiUrl, '/customers', {'search': search});
    } else {
      uri = Uri.https(Constants.baseApiUrl, '/customers');
    }
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      _customers = respBody.map((e) => CustomerModel.fromJson(e)).toList();
    }
    _isSearchingAll = false;
    notifyListeners();
  }

  Future<String?> add(CustomerModel customer) async {
    _isAdding = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/customer');
    http.Response resp = await http.post(url,
        body: jsonEncode(customer.toJson()), headers: _getHeader());
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isAdding = false;
    notifyListeners();
    return error;
  }

  Future<String?> update(CustomerModel customer) async {
    _isUpdating = true;
    notifyListeners();
    final url = Uri.https(Constants.baseApiUrl, '/customer');
    http.Response resp = await http.put(url,
        body: jsonEncode(customer.toJson()), headers: _getHeader());
    String? error;
    if (resp.statusCode != 200) {
      error = resp.body;
    }
    _isUpdating = false;
    notifyListeners();
    return error;
  }

  Future<List<CustomerModel>> getCustomerNames({String? search}) async {
    Uri uri;
    if (search != null && search.isNotEmpty) {
      uri = Uri.https(
          Constants.baseApiUrl, '/customer/names', {'search': search});
    } else {
      uri = Uri.https(Constants.baseApiUrl, '/customer/names');
    }
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      List respBody = jsonDecode(resp.body) as List;
      List<CustomerModel> customernames =
          respBody.map((e) => CustomerModel.fromJson(e)).toList();
      return customernames;
    }
    return [];
  }

  void setViewCustomer(CustomerModel customer) {
    _viewCustomer = customer;
    notifyListeners();
  }

  Map<String, String> _getHeader() {
    return Constants.requestHeader
      ..addAll({"authtoken": UserManagement.token ?? ''});
  }

  List<CustomerModel> get customers => List.unmodifiable(_customers);
  @override
  bool get isSearchingAll => _isSearchingAll;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  CustomerModel get viewCustomer => _viewCustomer;
}
