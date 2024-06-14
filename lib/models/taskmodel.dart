import 'package:cloud_firestore/cloud_firestore.dart';

class Taskmodel {
  String? id;
  String? userid;
  String? title;
  String? body;
  int? status;
  DateTime? createdAt;

  Taskmodel({this.id, this.title, this.body, this.status,this.userid, this.createdAt});

  factory Taskmodel.fromjson(DocumentSnapshot json) {
    Timestamp? timestamp = json['createdAt'];
    return Taskmodel(
      id: json['id'],
      title: json['title'],
      userid: json['userid'],
      body: json['body'],
      status: json['status'],
      createdAt: timestamp?.toDate(),
    );
  }
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      "title": title,
      'body': body,
      'userid':userid,
      'status': status,
      'createdAt': createdAt
    };
  }
}
