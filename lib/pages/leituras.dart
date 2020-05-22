import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:livros/pages/editar.dart';
import 'package:livros/models/livro.dart';

class LivroList extends StatelessWidget {
  final List<Livro> livros;
  //constructor
  LivroList({Key key, this.livros}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          String ok;
          if (livros[index].read == true) {
            ok = "Lido";
          } else {
            ok = "Não lido";
          }

          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                elevation: 5.0,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          livros[index].imageurl,
                          alignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                          width: 80.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(livros[index].title,
                                    style: TextStyle(
                                        fontFamily: 'PatrickHandSC',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(livros[index].year.toString(),
                                    style: TextStyle(
                                        fontFamily: 'PatrickHandSC',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(livros[index].author,
                                    style: TextStyle(
                                        fontFamily: 'PatrickHandSC',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(ok,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        backgroundColor: Colors.red,
                                        fontStyle: FontStyle.italic)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onLongPress: () {
              int selectedId = livros[index].id;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Editar(id: selectedId)));
            },
          );
        },
        itemCount: livros.length,
      ),
    );
  }
}

class Lido extends StatefulWidget {
  final bool lido;
  Lido({this.lido}) : super();
  @override
  State<StatefulWidget> createState() {
    return _LidoState();
  }
}

class _LidoState extends State<Lido> {
  @override
  Widget build(BuildContext context) {
    String nomepagina;

    if (widget.lido == true) {
      nomepagina = "Livros que já lí";
    } else {
      nomepagina = "Livros que lerei";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nomepagina,
          style: new TextStyle(
              color: Colors.black, fontFamily: 'Pacifico', fontSize: 25.0),
        ),
      ),
      body: FutureBuilder(
          future: fetchLidos(widget.lido),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? LivroList(livros: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
