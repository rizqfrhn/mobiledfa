import 'package:mobiledfa/Task/acreceive.dart';
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

class Document extends StatefulWidget {
  String nik;
  String scheduling;
  String namaToko;

  Document({Key key, @required this.nik, @required this.scheduling, @required this.namaToko});

  @override
  _Document createState() => _Document(nik: nik, scheduling: scheduling, namaToko: namaToko);
}

class _Document extends State<Document> {
  String nik;
  String scheduling;
  String namaToko;

  _Document({Key key, @required this.nik, @required this.scheduling, @required this.namaToko});

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
      fetchDataDoc(scheduling, namaToko);
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('List Document',
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
            itemCount: listDocument.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 60,
                child: MaterialButton(
                  elevation: 1.0,
                  highlightElevation: 1.0,
                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SKUReceive(nik: nik, scheduling: listDocument[i].sch_name, buktiDokumen: listDocument[i].no_doc,)),); },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        listDocument[i].no_doc,
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