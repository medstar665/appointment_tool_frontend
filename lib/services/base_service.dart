import 'package:flutter/foundation.dart';

abstract class BaseService extends ChangeNotifier {
  Future get({required int id});
  Future<void> getAll({String? search});
  Future<void> onPreviousPage();
  Future<void> onFirstPage();
  Future<void> onNextPage();
  Future<void> onLastPage();
  bool get isSearchingAll;
  int get currentPage;
  int? get totalPage;
}
