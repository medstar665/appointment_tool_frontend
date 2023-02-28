import 'package:flutter/foundation.dart';

abstract class BaseService extends ChangeNotifier {
  Future get({required int id});
  Future<void> getAll({String? search});
  bool get isSearchingAll;
}
