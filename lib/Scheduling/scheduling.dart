import 'package:mobiledfa/Scheduling/sequence.dart';
import 'schedulingmodel.dart';
import 'schedulingcontroller.dart';
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

class Scheduling extends StatefulWidget {
  String nik;

  Scheduling({Key key, @required this.nik}) : super(key: key);

  @override
  _Scheduling createState() => _Scheduling(nik: nik);
}

class _Scheduling extends State<Scheduling> {
  String nik;

  _Scheduling({Key key, @required this.nik});

  bool loading = false;
  bool firstload;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String periode = 'O${year}${month}';
  bool isLoaded = false;
  Color darkBlue = Color(0xff071d40);
  Icon actionIcon = new Icon(Icons.search);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
      refreshList();
      new Timer.periodic(Duration(seconds: 20),  (Timer firstTime) =>
          setState((){
            refreshList();
            firstTime.cancel();
          })
      );
      new Timer.periodic(Duration(seconds: 300),  (Timer t) => setState((){refreshList();}));
    });

  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      fetchDataSch(nik);
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('List Schedule',
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
          child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: list.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.all(8.0),
                height: 60,
                child: MaterialButton(
                  elevation: 1.0,
                  highlightElevation: 1.0,
                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Sequence(nik: nik, namaSopir: list[i].driver_name, scheduling: list[i].sch_name)),); },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        list[i].sch_name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }
}