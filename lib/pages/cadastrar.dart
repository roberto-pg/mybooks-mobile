import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:livros/models/livro.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class Cadastrar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CadastrarState();
  }
}

class _CadastrarState extends State<Cadastrar> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String title, author, nationality, year, read, aviso;
  int _radioValue = 0;
  bool _result = false;
  File imageurl;

  void mudarValor(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = false;
          break;
        case 1:
          _result = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Meu livro novo',
            style: new TextStyle(
                color: Colors.black, fontFamily: 'Pacifico', fontSize: 25.0),
          ),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: EdgeInsets.all(15.0),
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: _formUI(),
            ),
          ),
        ));
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Título',
            ),
            validator: _validarTitulo,
            onSaved: (String val) {
              title = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Autor',
            ),
            validator: _validarAutor,
            onSaved: (String val) {
              author = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'País',
            ),
            validator: _validarNacionalidade,
            onSaved: (String val) {
              nationality = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Ano',
            ),
            validator: _validarAno,
            onSaved: (String val) {
              year = val;
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Escolha a Capa:',
                    style: TextStyle(
                        fontFamily: 'PatrickHandSC',
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold)),
                Padding(padding: const EdgeInsets.only(right: 50)),
                Container(
                  width: 50,
                  height: 50,
                  child: OutlineButton(
                      child: imageurl == null
                          ? Icon(Icons.camera_alt)
                          : new Image.file(imageurl),

                      // Icon(Icons.camera_alt),

                      onPressed: openGallery,
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0),
                      padding: const EdgeInsets.all(2.0)),
                )
              ],
            )),
        Row(
          children: <Widget>[
            Text('Escolha o Status:',
                style: TextStyle(
                    fontFamily: 'PatrickHandSC',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text('Lido',
                  style: TextStyle(
                      fontFamily: 'PatrickHandSC',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold)),
            ),
            new Radio(
              value: 1,
              groupValue: _radioValue,
              onChanged: mudarValor,
            ),
            Text('Não lido',
                style: TextStyle(
                    fontFamily: 'PatrickHandSC',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold)),
            new Radio(
              value: 0,
              groupValue: _radioValue,
              onChanged: mudarValor,
            ),
          ],
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: _sendForm,
          //FocusScope.of(context).requestFocus(new FocusNode());
          child: new Text('Enviar'),
        )
      ],
    );
  }

  String _validarTitulo(String value) {
    if (value.length == 0) {
      aviso = "Informe o título";
    }
    return aviso;
  }

  String _validarAutor(String value) {
    if (value.length == 0) {
      aviso = "Informe o autor";
    }
    return aviso;
  }

  String _validarNacionalidade(String value) {
    if (value.length == 0) {
      aviso = "Informe o país do autor";
    }
    return aviso;
  }

  String _validarAno(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o ano do livro";
    } else if (!regExp.hasMatch(value)) {
      return "Esse campo só aceita números";
    }
    return null;
  }

  _sendForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();

      if (imageurl == null) {
        _avisoErroImagem();
      }

      String filename = imageurl.path;

      FormData formData = new FormData.fromMap({
        "title": title,
        "author": author,
        "nationality": nationality,
        "imageurl": await MultipartFile.fromFile(imageurl.path,
            filename: filename, contentType: MediaType('image', 'png')),
        "year": year,
        "read": _result,
      });
      await addLivro(formData);
      await fetchLivros();

      Navigator.pop(context); //Quit Dialog
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }

  openGallery() async {
    var imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageurl = imagePicker;
    });
  }

  _avisoErroImagem() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Falha na operação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Selecione uma imagem de capa para enviar")
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Fechar'),
                onPressed: () async {
                  Navigator.pop(context); //Quit Dialog
                },
              ),
            ],
          );
        });
  }
}
