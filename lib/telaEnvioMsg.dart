import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'env.dart';

class telaEnvioMsg extends StatefulWidget {
  telaEnvioMsg({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaEnvioMsg createState() => _telaEnvioMsg();
}

class _telaEnvioMsg extends State<telaEnvioMsg> {
  TextEditingController mailController = new TextEditingController();
  int tema = 1;

  CollectionReference msg = FirebaseFirestore.instance.collection('messages');
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  Future<Void> addMsg() async {
    List<String> listaUsuarios = new List<String>();
    await user
        .where('subs', arrayContains: tema)
        .get()
        .then((value) => value.docs.forEach((element) {
              listaUsuarios.add(element.id);
            }));

    for (var element in listaUsuarios) {
      msg.add({
        'userId': element,
        'nomeRemetente': Env.loggedUser.name,
        'tipo': tema,
        'corpoMensagem': mailController.text
      }).catchError((error) => print("Failed to add user: $error"));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nova Mensagem"),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: mailController,
                    obscureText: false,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mensagem',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  RadioListTile<int>(
                    title: const Text('Jogos'),
                    value: 1,
                    groupValue: tema,
                    onChanged: (int value) {
                      setState(() {
                        tema = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Noticias'),
                    value: 2,
                    groupValue: tema,
                    onChanged: (int value) {
                      setState(() {
                        tema = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Estudo'),
                    value: 3,
                    groupValue: tema,
                    onChanged: (int value) {
                      setState(() {
                        tema = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Social'),
                    value: 4,
                    groupValue: tema,
                    onChanged: (int value) {
                      setState(() {
                        tema = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar')),
                      RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: addMsg,
                          child: Text('Enviar Mensagem'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
