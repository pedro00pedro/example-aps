import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'telaCadastro.dart';
import "user.dart";
import 'env.dart';
import 'telaPrincipal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: "Teste",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<User> futureUser;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future loginAttempt() async {
    String userEmail;
    String userName;
    String userId;
    List<dynamic> subs = [];
    List<dynamic> subsInt = [];

    final result = await users
        .where('email', isEqualTo: emailController.text)
        .where('pass', isEqualTo: passController.text)
        .get()
        .then((value) => {
              if (value.size == 1)
                {
                  userEmail = value.docs[0].get('email'),
                  userName = value.docs[0].get('name'),
                  userId = value.docs[0].id,
                  subs = value.docs[0].get('subs'),
                  subsInt = subs.cast<int>(),
                  Env.loggedUser = new User(
                      id: userId,
                      email: userEmail,
                      name: userName,
                      subs: subsInt),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => telaPrincipal()),
                  )
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: "Email/Senha incorreto(s)!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.lightBlueAccent,
                      textColor: Colors.white)
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                controller: emailController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: passController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Senha',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: loginAttempt,
                      child: Text('Acessar')),
                  RaisedButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaCadastro()),
                        );
                      },
                      child: Text('Cadastrar-se')),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
