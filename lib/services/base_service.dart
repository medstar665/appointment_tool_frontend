import 'package:flutter/foundation.dart';
import 'package:medstar_appointment/utility/constants.dart';

abstract class BaseService extends ChangeNotifier {
  Future get({required int id});
  Future<void> getAll({String? search});
  Future<void> onPreviousPage();
  Future<void> onFirstPage();
  Future<void> onNextPage();
  Future<void> onLastPage();
  bool get isSearchingAll;
  int get currentPage;
  int? get totalElements;
  int? get totalPage {
    return totalElements == null
        ? null
        : (totalElements! % Constants.pageSize == 0)
            ? totalElements! ~/ Constants.pageSize
            : (totalElements! ~/ Constants.pageSize) + 1;
  }
}
