import 'dart:io';
import 'package:flutter/material.dart';
import 'package:livros/pages/cadastrar.dart';
import 'package:livros/pages/leituras.dart';
import 'pages/estante.dart';
import 'loginPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var status, total;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    loadTotal();
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      if (status == 'true') {
        return Scaffold(
          backgroundColor: Color(0xFFffffff),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Minha biblioteca',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pacifico',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal),
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'Lista' + '\n' 'de' + '\n' 'leitura',
                    style: TextStyle(fontFamily: 'Pacifico', fontSize: 40.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'imagens/capa.jpg',
                    fit: BoxFit.fill,
                    width: 150.0,
                  ),
                )
              ],
            ),
          ),
          drawer: _buildDrawer(context),
        );
      } else {
        return Scaffold(
          backgroundColor: Color(0xFFffffff),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Minha biblioteca',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pacifico',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal),
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'Lista' + '\n' 'de' + '\n' 'leitura',
                    style: TextStyle(fontFamily: 'Pacifico', fontSize: 40.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'imagens/capa.jpg',
                    fit: BoxFit.fill,
                    width: 150.0,
                  ),
                )
              ],
            ),
          ),
          drawer: _buildDrawer2(context),
        );
      }
    } else if (MediaQuery.of(context).orientation == Orientation.landscape) {
      if (status == 'true') {
        return Scaffold(
          backgroundColor: Color(0xFFffffff),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Minha biblioteca',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pacifico',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 10, 50, 30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Lista' + '\n' 'de' + '\n' 'leitura',
                        style:
                            TextStyle(fontFamily: 'Pacifico', fontSize: 40.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(130, 20, 50, 30),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'imagens/capa.jpg',
                        fit: BoxFit.fill,
                        width: 150.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          drawer: _buildDrawer(context),
        );
      } else {
        return Scaffold(
          backgroundColor: Color(0xFFffffff),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Minha biblioteca',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pacifico',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 10, 50, 30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Lista' + '\n' 'de' + '\n' 'leitura',
                        style:
                            TextStyle(fontFamily: 'Pacifico', fontSize: 40.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(130, 20, 50, 30),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'imagens/capa.jpg',
                        fit: BoxFit.fill,
                        width: 150.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          drawer: _buildDrawer2(context),
        );
      }
    }
    return null;
  }

  Drawer _buildDrawer(context) {
    return new Drawer(
        child: new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.asset(
                  'imagens/capa2.jpg',
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.cover,
                ),
                new Text(
                  'Roberto',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Pacifico'),
                ),
                new Text('Minhas Leituras',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontFamily: 'Pacifico'))
              ],
            ),
          ),
          decoration: new BoxDecoration(color: Colors.blue),
        ),
        new ListTile(
          leading: new Icon(Icons.library_books),
          title: new Text(
            'Minha estante',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          trailing: Text(
            total == null ? 'null' : total + ' livros',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Estante()));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.check_box),
          title: new Text(
            'Livros lidos',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Lido(lido: true)));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.check_box_outline_blank),
          title: new Text(
            'Livros não lidos',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Lido(lido: false)));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.fiber_new),
          title: new Text(
            'Novo livro',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Cadastrar()));
          },
        ),
        new Divider(
          color: Colors.black45,
          indent: 16.0,
        ),
        new ListTile(
          title: new Text(
            'Logout',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () async {
            await storage.deleteAll();
            exit(0);
            //Navigator.popUntil(context, ModalRoute.withName("/"));
          },
        ),
        new ListTile(
          title: new Text(
            'Fechar',
            style: new TextStyle(fontFamily: 'Pacifico'),
          ),
          onTap: () => {exit(0)},
        )
      ],
    ));
  }

  Drawer _buildDrawer2(context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.asset(
                    'imagens/capa2.jpg',
                    width: 70.0,
                    height: 70.0,
                    fit: BoxFit.cover,
                  ),
                  new Text(
                    'Roberto',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'Pacifico'),
                  ),
                  new Text('Minhas Leituras',
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: 'Pacifico'))
                ],
              ),
            ),
            decoration: new BoxDecoration(color: Colors.blue),
          ),
          new ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: new Text(
              'Entrar',
              style: new TextStyle(fontFamily: 'Pacifico'),
            ),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          new ListTile(
            leading: new Icon(Icons.close),
            title: new Text(
              'Fechar',
              style: new TextStyle(fontFamily: 'Pacifico'),
            ),
            onTap: () => {exit(0)},
          ),
        ],
      ),
    );
  }

  Future loadData() async {
    status = await storage.read(key: 'nameKey');
    setState(() {
      this.status = status;
    });
  }

  Future loadTotal() async {
    total = await storage.read(key: 'totalEstante');
    setState(() {
      this.total = total;
    });
  }
}
