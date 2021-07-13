import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  List<int> subs = [];

  User({this.id, this.name, this.email, this.subs});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['usuario_email'],
        name: json['usuario_nome'],
        id: json['usuario_id']);
  }

  factory User.fromFirestore(QuerySnapshot<Object> user) {
    String email = user.docs[0].get('email');
    String name = user.docs[0].get('name');
    String idUser = user.docs[0].get('id');
    return User(id: idUser, name: name, email: email);
  }

  Map<String, dynamic> toJson() => {
        'usuario_nome': name,
        'usuario_email': email,
      };
}
