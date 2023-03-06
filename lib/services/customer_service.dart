import 'dart:convert';

import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/model/paginate.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:http/http.dart' as http;

class CustomerService extends BaseService {
  List<CustomerModel> _customers = [];
  bool _isSearchingAll = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  int _currentPage = 1;
  int? _totalElements;
  String? _searchValue;
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
  Future<void> getAll({int? pageNum, String? search}) async {
    _isSearchingAll = true;
    notifyListeners();
    _searchValue = search;
    Uri uri;
    if (_searchValue != null && _searchValue!.isNotEmpty) {
      uri = Uri.https(Constants.baseApiUrl, '/customers', {
        'pageNum': '${pageNum ?? 1}',
        'pageSize': '${Constants.pageSize}',
        'search': _searchValue,
      });
    } else {
      uri = Uri.https(Constants.baseApiUrl, '/customers', {
        'pageNum': '${pageNum ?? 1}',
        'pageSize': '${Constants.pageSize}',
      });
    }
    http.Response resp = await http.get(uri, headers: _getHeader());
    if (resp.statusCode == 200) {
      final customerPage = PaginatedResponse<CustomerModel>.fromJson(
          jsonDecode(resp.body), CustomerModel.fromJson);
      _customers = customerPage.data ?? [];
      _currentPage = customerPage.pageNum;
      _totalElements = customerPage.totalElements!;
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
      final customerPage = PaginatedResponse<CustomerModel>.fromJson(
          jsonDecode(resp.body), CustomerModel.fromJson);
      return customerPage.data ?? [];
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

  @override
  int get currentPage => _currentPage;

  @override
  int get totalElements => _totalElements ?? 0;

  @override
  Future<void> onNextPage() async {
    await getAll(pageNum: _currentPage + 1, search: _searchValue);
  }

  @override
  Future<void> onPreviousPage() async {
    await getAll(pageNum: _currentPage - 1, search: _searchValue);
  }

  @override
  Future<void> onFirstPage() async {
    await getAll(pageNum: 1, search: _searchValue);
  }

  @override
  Future<void> onLastPage() async {
    await getAll(pageNum: totalPage, search: _searchValue);
  }
}
