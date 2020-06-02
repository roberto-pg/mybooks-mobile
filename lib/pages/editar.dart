import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:livros/mainPage.dart';
import 'package:livros/models/livro.dart';

class Editar extends StatefulWidget {
  final int id;
  Editar({this.id}) : super();
  @override
  State<StatefulWidget> createState() {
    return _EditarState();
  }
}

class _EditarState extends State<Editar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alterar ou excluir',
          style: new TextStyle(
              color: Colors.black, fontFamily: 'Pacifico', fontSize: 25.0),
        ),
      ),
      body: FutureBuilder(
          future: fetchId(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? EditarList(livros: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class EditarList extends StatefulWidget {
  final Livro livros;
  EditarList({Key key, this.livros}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditarListState();
  }
}

class _EditarListState extends State<EditarList> {
  Livro livros = new Livro();
  int _radioValue = 0;
  String _result = "false";

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = 'false';
          break;
        case 1:
          _result = 'true';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.livros = Livro.fromTask(widget.livros);

    String status;
    if (this.livros.read == true) {
      status = "Lido";
    } else {
      status = "Não lido";
    }
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(this.livros.imageurl,
                        alignment: Alignment.topLeft,
                        fit: BoxFit.cover,
                        width: 80.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(this.livros.title,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.author,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.nationality,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.year.toString(),
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Text('Status:',
                                  style: TextStyle(
                                      fontFamily: 'PatrickHandSC',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(status,
                                style: TextStyle(
                                    fontFamily: 'PatrickHandSC',
                                    fontSize: 17.0,
                                    backgroundColor: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Escolha o Status:',
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text('Lido',
                              style: TextStyle(
                                  fontFamily: 'PatrickHandSC',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('Não lido',
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              child: Text("Alterar"),
                              color: Theme.of(context).accentColor,
                              elevation: 4.0,
                              onPressed: () async {
                                //Update an existing task ?
                                Map<String, dynamic> params =
                                    Map<String, dynamic>();
                                params["read"] = _result;
                                int id = this.livros.id;
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Confirmação"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  "Deseja alterar o Status do livro ?")
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('Sim'),
                                            onPressed: () async {
                                              //Altera o Status do livro
                                              await updateLivro(id, params);
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainPage())); //Quit Dialog
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text('Não'),
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context); //Quit Dialog
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text("Deletar"),
                            color: Theme.of(context).accentColor,
                            elevation: 4.0,
                            onPressed: () async {
                              //Show "Confirmation dialog"
                              int id = this.livros.id;
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmação"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                "Deseja excluir este livro da lista ?")
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text('Sim'),
                                          onPressed: () async {
                                            //Deleta o livro
                                            await deleteLivro(id);
                                            await fetchLivros();
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage()));
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text('Não'),
                                          onPressed: () async {
                                            Navigator.pop(
                                                context); //Quit to previous screen
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(this.livros.imageurl,
                        alignment: Alignment.topLeft,
                        fit: BoxFit.cover,
                        width: 80.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(this.livros.title,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.author,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.nationality,
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(this.livros.year.toString(),
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Text('Status:',
                                  style: TextStyle(
                                      fontFamily: 'PatrickHandSC',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(status,
                                style: TextStyle(
                                    fontFamily: 'PatrickHandSC',
                                    fontSize: 17.0,
                                    backgroundColor: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  //Padding(
                  //padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 150, right: 30),
                          child: RaisedButton(
                              child: Text("Alterar"),
                              color: Theme.of(context).accentColor,
                              elevation: 4.0,
                              onPressed: () async {
                                //Update an existing task ?
                                Map<String, dynamic> params =
                                    Map<String, dynamic>();
                                params["read"] = _result;
                                int id = this.livros.id;
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Confirmação"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  "Deseja alterar o Status do livro ?")
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('Sim'),
                                            onPressed: () async {
                                              //Altera o Status do livro
                                              await updateLivro(id, params);
                                              Navigator.pop(
                                                  context); //Quit Dialog
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainPage()));
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text('Não'),
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context); //Quit Dialog
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 150, right: 30),
                          child: RaisedButton(
                            child: Text("Deletar"),
                            color: Theme.of(context).accentColor,
                            elevation: 4.0,
                            onPressed: () async {
                              //Show "Confirmation dialog"
                              int id = this.livros.id;
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmação"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                "Deseja excluir este livro da lista ?")
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text('Sim'),
                                          onPressed: () async {
                                            //Deleta o livro
                                            await deleteLivro(id);
                                            await fetchLivros();
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage()));
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text('Não'),
                                          onPressed: () async {
                                            Navigator.pop(
                                                context); //Quit to previous screen
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Escolha o Status:',
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text('Lido',
                              style: TextStyle(
                                  fontFamily: 'PatrickHandSC',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('Não lido',
                            style: TextStyle(
                                fontFamily: 'PatrickHandSC',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
