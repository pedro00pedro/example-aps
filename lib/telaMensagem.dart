import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class telaMensagem extends StatefulWidget {
  telaMensagem(Message msg) {
    this.msg = msg;
  }

  Message msg;

  @override
  _telaMensagem createState() => _telaMensagem(msg);
}

class _telaMensagem extends State<telaMensagem> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Message msg;

  _telaMensagem(Message msg) {
    this.msg = msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mensagem"),
        ),
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tema:  " + msg.getTipoString(),
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Autor:  " + msg.nomeRemetente,
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Mensagem:  " + msg.corpoMensagem,
              style: TextStyle(fontSize: 30),
            )
          ],
        )));
  }
}
