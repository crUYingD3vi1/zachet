import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class Info{
  final String Author;
  final String Discord;
  final String Version;

  Info({this.Author, this.Discord, this.Version});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      Author: json['Author'],
      Discord: json['Discord'],
        Version: json['Version'],
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url;


  TestHttp({String url}):url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
}// TestHttp

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  String _url;
  Info _info;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    http.get(_url).then((response) {
      _info = Info.fromJson(json.decode(response.body));

      setState(() {});
    }).catchError((error) {
      _info = Info(
        Author: '',
        Discord: error.toString(),
        Version: '',
      );


      setState(() {});
    });


    Widget build(BuildContext context) {
      return Form(key: _formKey, child: SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
              child: Text('API url',
                  style: TextStyle(fontSize: 20.0, color: Colors.blue)),
              padding: EdgeInsets.all(10.0)
          ),
          Container(
              child: TextFormField(initialValue: _url, validator: (value) {
                if (value.isEmpty) return 'Поле не должно быть пустым';
              }, onSaved: (value) {
                _url = value;
              }, autovalidate: true),
              padding: EdgeInsets.all(10.0)
          ),
          SizedBox(height: 20.0),
          RaisedButton(
              child: Text('отправить запрос'), onPressed: _sendRequestGet),
          Text('Информация',
              style: TextStyle(fontSize: 20.0, color: Colors.red)),
          Text(_info == null ? '' : _info.Author),
          Text(_info == null ? '' : _info.Discord),
          Text(_info == null ? '' : _info.Version),
        ],
      )));
    } //build
  } //TestHttpState

  class MyApp extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('зачётная работа'),
  actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
  })],
  ),
  body: TestHttp(url: 'https://api.jikan.moe/v3')
  );
  }
  }

  void main() => runApp(
  MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp()
  )
  );
}