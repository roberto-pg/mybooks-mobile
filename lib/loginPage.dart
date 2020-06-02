import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livros/mainPage.dart';
import 'package:livros/models/login.dart';
import 'models/livro.dart';

final storage = new FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String email, password, aviso;
  var nameKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
        title: Text(
          'Login',
          style: new TextStyle(
              color: Colors.black, fontFamily: 'Pacifico', fontSize: 25.0),
        ),
      ),
      body: new SingleChildScrollView(
        child: Container(
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: _formUI(),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Image.asset(
            'imagens/capa.jpg',
            fit: BoxFit.fill,
            width: 150.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite o Email';
              }
              return null;
            },
            onSaved: (String val) {
              email = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite a Senha';
              }
              return null;
            },
            onSaved: (String val) {
              password = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
              onPressed: _sendForm,
              color: Colors.white24,
              child: Text('LOGIN'),
              textColor: Colors.red,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.only(left: 60, right: 60)),
        )
      ],
    );
  }

  _sendForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();

      Map<String, dynamic> params = Map<String, dynamic>();
      params["email"] = email;
      params["password"] = password;

      await getToken(params);

      var token = await storage.read(key: 'jwt');

      if (token != null) {
        await saveData();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        _key.currentState?.reset();
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erro de validação"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Os dados informados estão incorretos")
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
  }

  Future saveData() async {
    await storage.write(key: 'nameKey', value: 'true');
    await fetchLivros();
  }
}
