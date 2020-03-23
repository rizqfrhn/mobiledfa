import 'package:mobiledfa/Task/document.dart';
import 'taskmodel.dart';
import 'taskcontroller.dart';
import '../Services/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Task extends StatefulWidget {
  String nik;
  String scheduling;

  Task({Key key, @required this.nik, @required this.scheduling});

  @override
  _Task createState() => _Task(nik: nik, scheduling: scheduling);
}

class _Task extends State<Task> {
  String nik;
  String scheduling;

  _Task({Key key, @required this.nik, @required this.scheduling});

  bool loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
      refreshList();
      new Timer.periodic(Duration(seconds: 3),  (Timer firstTime) =>
          setState((){
            refreshList();
            firstTime.cancel();
          })
      );
    });

  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      fetchDataTask(scheduling);
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('List Toko',
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
            itemCount: listTask.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 60,
                child: MaterialButton(
                  elevation: 1.0,
                  highlightElevation: 1.0,
                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Document(nik: nik, scheduling: listTask[i].sch_name, namaToko: listTask[i].nama_toko)),); },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        listTask[i].nama_toko,
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