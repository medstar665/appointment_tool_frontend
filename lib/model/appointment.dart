import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/model/service.dart';

class AppointmentModel {
  int? id;
  late int customerId;
  late int serviceId;
  CustomerModel? customer;
  ServiceModel? service;
  DateTime? appointmentDateTime;
  String? status;
  int? duration;
  String? color;

  AppointmentModel({
    this.id,
    required this.customerId,
    required this.serviceId,
    this.customer,
    this.service,
    this.appointmentDateTime,
    this.status,
    this.duration,
    this.color,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'] ?? 0;
    serviceId = json['facilityId'] ?? 0;
    if (json['customer'] != null) {
      customer = CustomerModel.fromJson(json['customer']);
    }
    if (json['facility'] != null) {
      service = ServiceModel.fromJson(json['facility']);
    }
    if (json['appointmentDateTime'] != null) {
      appointmentDateTime = DateTime.parse(json['appointmentDateTime']);
    }
    if (json['status'] != null) {
      status = json['status'];
    }
    if (json['duration'] != null) {
      duration = json['duration'] ?? 0;
    }
    if (json['color'] != null) color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['customerId'] = customerId;
    data['facilityId'] = serviceId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (service != null) {
      data['facility'] = service!.toJson();
    }
    if (appointmentDateTime != null) {
      data['appointmentDateTime'] = appointmentDateTime!.toIso8601String();
    }
    if (status != null) {
      data['status'] = status;
    }
    if (duration != null) {
      data['duration'] = duration;
    }
    if (color != null) {
      data['color'] = color;
    }
    return data;
  }
}
