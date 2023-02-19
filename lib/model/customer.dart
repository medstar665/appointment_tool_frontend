class CustomerModel {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? phone;
  String? email;
  String? note;

  CustomerModel({
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.phone,
    this.email,
    this.note,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (dob != null) data['dob'] = dob;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (note != null) data['note'] = note;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
