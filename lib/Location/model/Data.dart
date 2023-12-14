import 'dart:convert';

class Data {
  Data({
      this.message, 
      this.status,});

  Data.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
  }
  String? message;
  bool? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}