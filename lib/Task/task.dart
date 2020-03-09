import 'taskmodel.dart';
import 'taskcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
/*import 'package:fl_chart/fl_chart.dart' as mainchart;*/
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:intl/intl.dart';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();
var monthFormat = new DateFormat("MMMM").format(now);
var yearFormat = new DateFormat("yyyy").format(now);
var monthComboBox = new DateFormat("MMMM").format(now);
var yearComboBox = new DateFormat("yyyy").format(now);
final numformat = new NumberFormat("#,###");
bool isFilter = false;

class Task extends StatefulWidget {
  String nik;

  Task({Key key, @required this.nik}) : super(key: key);

  @override
  _Task createState() => _Task(nik: nik);
}

class _Task extends State<Task> {
  String nik;

  _Task({Key key, @required this.nik});

  bool loading = false;
  bool firstload;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  PeriodeModel periodeSelection;
  String periode = 'O${year}${month}';
  bool isLoaded = false;
  Color darkBlue = Color(0xff071d40);
  Icon actionIcon = new Icon(Icons.search);

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Scheduling',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue])
          ),
        ),
        actions: <Widget>[
          /*_appBar(),*/
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        key: refreshKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              new Container(
                child: new Column(
                  children: <Widget>[
                    new Card(
                      child: new Column(
                        children: <Widget>[
                          new Image.network('https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg'),
                          new Padding(
                              padding: new EdgeInsets.all(7.0),
                              child: new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.all(7.0),
                                    child: new Icon(Icons.thumb_up),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(7.0),
                                    child: new Text('Like',style: new TextStyle(fontSize: 18.0),),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(7.0),
                                    child: new Icon(Icons.comment),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(7.0),
                                    child: new Text('Comments',style: new TextStyle(fontSize: 18.0)),
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }
}
