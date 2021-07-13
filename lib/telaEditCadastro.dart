import 'package:flutter/material.dart';
import 'main.dart';
import 'env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "user.dart";
import 'package:fluttertoast/fluttertoast.dart';

class telaEditCadastro extends StatefulWidget {
  telaEditCadastro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaEditCadastro createState() => _telaEditCadastro();
}

class _telaEditCadastro extends State<telaEditCadastro> {
  TextEditingController emailController =
      new TextEditingController(text: Env.loggedUser.email);
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController =
      new TextEditingController(text: Env.loggedUser.name);

  bool tema1 = Env.loggedUser.subs.contains(1);
  bool tema2 = Env.loggedUser.subs.contains(2);
  bool tema3 = Env.loggedUser.subs.contains(3);
  bool tema4 = Env.loggedUser.subs.contains(4);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    List<int> subList = [];

    if (tema1) subList.add(1);
    if (tema2) subList.add(2);
    if (tema3) subList.add(3);
    if (tema4) subList.add(4);

    User editedUser = new User(
        email: emailController.text,
        name: nameController.text,
        id: Env.loggedUser.id,
        subs: subList);
    Env.loggedUser = editedUser;
    return users
        .doc(Env.loggedUser.id)
        .update({'subs': subList})
        .then((value) => {
              Fluttertoast.showToast(
                  msg: "Alterações salvas!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
              Navigator.pop(context)
            })
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar Subs: " + Env.loggedUser.name),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text("Jogos"),
                    value: tema1,
                    onChanged: (bool value) {
                      setState(() {
                        tema1 = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Noticias"),
                    value: tema2,
                    onChanged: (bool value) {
                      setState(() {
                        tema2 = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Estudo"),
                    value: tema3,
                    onChanged: (bool value) {
                      setState(() {
                        tema3 = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Social"),
                    value: tema4,
                    onChanged: (bool value) {
                      setState(() {
                        tema4 = value;
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
                          child: Text('Voltar')),
                      RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: addUser,
                          child: Text('Salvar'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
