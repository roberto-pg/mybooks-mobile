import 'dart:async';
import 'package:dio/dio.dart';
import 'package:livros/global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class User {
  int id;
  String email;
  String password;

  User({this.id, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], email: json['email'], password: json['password']);
  }
}

Future<Map> getToken(params) async {
  Dio dio = new Dio();
  Response response;
  var chave;
  try {
    response = await dio.post('$URL_TOKEN', data: params);
    chave = response.data["token"];
    await storage.write(key: 'jwt', value: chave);
    //token = await storage.read(key: 'jwt');
  } on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }
  return null;
}
