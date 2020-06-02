import 'dart:async';
import 'dart:io';
import 'package:livros/global.dart';
import 'package:dio/dio.dart';
import 'package:livros/models/login.dart';

class Livro {
  int id;
  String title;
  String author;
  String nationality;
  String imageurl;
  int year;
  bool read;
  //Constructor
  Livro(
      {this.id,
      this.title,
      this.author,
      this.nationality,
      this.imageurl,
      this.year,
      this.read});
  //This is a static method
  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        nationality: json["nationality"],
        imageurl: json["imageurl"],
        year: json["year"],
        read: json["read"]);
  }
  //clone a Task, or "copy constructor"
  factory Livro.fromTask(Livro anotherTask) {
    return Livro(
        id: anotherTask.id,
        title: anotherTask.title,
        author: anotherTask.author,
        nationality: anotherTask.nationality,
        imageurl: anotherTask.imageurl,
        year: anotherTask.year,
        read: anotherTask.read);
  }
}

//Retorna todos os livros da Restful API
Future<List<Livro>> fetchLivros() async {
  Response response;
  Dio dio = new Dio();
  var livroEstante;
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);

  response = await dio.get(URL_LIVROS);
  if (response.statusCode == 200) {
    livroEstante = response.headers['x-total-count'][0].toString();
    await storage.write(key: 'totalEstante', value: livroEstante);

    Map<String, dynamic> mapResponse = response.data;
    final todos = mapResponse["data"].cast<Map<String, dynamic>>();
    final listOfLivros = await todos.map<Livro>((json) {
      return Livro.fromJson(json);
    }).toList();

    return listOfLivros;
  } else {
    throw Exception('Falha para carregar a lista de livros do webservice.');
  }
}

//Retorna os livros pelo atributo 'read' da Restful API
Future<List<Livro>> fetchLidos(bool read) async {
  Response response;
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  response = await dio.get('$URL_LIVRO_BY_LIDO$read');
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = response.data;
    if (response.statusCode == 200) {
      final tasks = mapResponse["data"].cast<Map<String, dynamic>>();
      return tasks.map<Livro>((json) {
        return Livro.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception("Falha para buscar livros pelo atributo 'read'");
  }
}

//Retorna um livro pelo atributo 'id' da Restful API
Future<Livro> fetchId(int id) async {
  Response response;
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  final String url = '$URL_LIVRO_BY_ID$id';
  response = await dio.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = response.data;
    Map<String, dynamic> mapTask = mapResponse["data"];
    return Livro.fromJson(mapTask);
  } else {
    throw Exception("Falha para buscar livro pelo 'id'");
  }
}

Future<Livro> updateLivro(int id, params) async {
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    await dio.patch('$URL_LIVRO_UPDATE$id', data: params);
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

// Adiciona um novo livro
Future<Map> addLivro(params) async {
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    await dio.post('$URL_LIVRO_ADD', data: params);
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

// //Delete a Task
Future<Livro> deleteLivro(int id) async {
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    final String url = '$URL_LIVRO_DELETE$id';
    await dio.delete(url);
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
