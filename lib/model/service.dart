class ServiceModel {
  int? id;
  String? title;
  String? description;
  int? fee;
  int? duration;
  String? color;

  ServiceModel({
    this.id,
    this.title,
    this.description,
    this.fee,
    this.duration,
    this.color,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    fee = json['fee'];
    duration = json['duration'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (fee != null) data['fee'] = fee;
    if (duration != null) data['duration'] = duration;
    if (color != null) data['color'] = color;
    return data;
  }
}
