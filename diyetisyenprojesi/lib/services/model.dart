import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadData {
  final String? username;
  final String? email;
  LoadData({this.username, this.email});

  factory LoadData.fromJson(Map<String, dynamic> json) {
    return LoadData(username: json['username'], email: json['email']);
  }
}

