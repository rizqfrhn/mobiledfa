import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();

class Navigation extends StatefulWidget {
  String nik;
  String periode;
  String lokasi;

  Navigation({Key key, @required this.nik, this.periode, this.lokasi}) : super(key: key);

  @override
  _Navigation createState() => new _Navigation();
}

class _Navigation extends State<Navigation> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String periode = 'O${year}${month}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Navigation',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                /*begin: Alignment.topRight,
                  end: Alignment.topLeft,*/
                  colors: [Colors.blue, Colors.lightBlue])
          ),
        ),
        /*leading: new Container(),*/
      ),
    );
  }
}
