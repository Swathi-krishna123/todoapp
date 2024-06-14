import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? password;
  String? uid;
  int? status;
  DateTime? createdAt;

  UserModel(
      {this.name,
      this.email,
      this.password,
      this.uid,
      this.status,
      this.createdAt});

  factory UserModel.fromjson(DocumentSnapshot data) {
    return UserModel(
        name: data['name'],
        email: data['email'],
        uid: data['uid'],
        password: data['password'],
        createdAt: data['createdAt'],
        status: data['status']);
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'uid': uid,
      'status': status,
      'createdAt': createdAt
    };
  }
}
