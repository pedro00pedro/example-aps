import 'package:flutter/material.dart';
import 'package:pub_sub_example/telaEnvioMsg.dart';
import 'env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'telaMensagem.dart';
import 'message.dart';
import 'telaEditCadastro.dart';

class telaPrincipal extends StatefulWidget {
  telaPrincipal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaPrincipal createState() => _telaPrincipal();
}

class _telaPrincipal extends State<telaPrincipal> {
  _telaPrincipal() {}
  ListTile _tile(
          String title, String subtitle, IconData icon, Message mensagem) =>
      ListTile(
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          subtitle: Text(subtitle),
          leading: Icon(
            icon,
            size: 50,
            color: Colors.blue[500],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => telaMensagem(mensagem)),
            );
          });
  ListView msgListView(context, List<Message> data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].nomeRemetente, data[index].getTipoString(),
              Icons.mail, data[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference listaMensagens =
        FirebaseFirestore.instance.collection('messages');
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá " + Env.loggedUser.name),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<QuerySnapshot<Object>>(
                future: listaMensagens
                    .where('userId', isEqualTo: Env.loggedUser.id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> newList = [];
                    String nomeRemetente;
                    int tipo;
                    String corpoMensagem;
                    String msgId;
                    String userId;
                    snapshot.data.docs.forEach((element) {
                      msgId = element.id;
                      userId = element.get('userId');
                      nomeRemetente = element.get('nomeRemetente');
                      tipo = element.get('tipo');
                      corpoMensagem = element.get('corpoMensagem');

                      Message msg = new Message(
                          nomeRemetente, tipo, corpoMensagem, msgId, userId);
                      newList.add(msg);
                    });

                    return msgListView(context, newList);
                  } else if (snapshot.hasError) {}

                  return CircularProgressIndicator();
                })
          ],
        ),
      )),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        child: ListView(
          // Important: Remove any pad
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              child: DrawerHeader(
                  child: Text(Env.loggedUser.name,
                      style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(20.0)),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Inscrever-se'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => telaEditCadastro()),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => telaEnvioMsg()),
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
