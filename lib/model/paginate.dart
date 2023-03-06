class PaginatedResponse<T> {
  late int pageNum;
  late int pageSize;
  int? totalElements;
  List<T>? data;

  PaginatedResponse({
    required this.pageNum,
    required this.pageSize,
    this.totalElements,
    this.data,
  });

  PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    pageNum = json['pageNum'] ?? 1;
    pageSize = json['pageSize'] ?? 10;
    totalElements = json['totalResult'];
    data = (json['result'] as List).map((e) => fromJson(e)).toList();
  }
}
