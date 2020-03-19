import 'package:mobiledfa/General/generalcontroller.dart';
import 'package:mobiledfa/Scheduling/sequence.dart';
import 'package:mobiledfa/Task/taskcontroller.dart';
import 'package:mobiledfa/Task/task.dart';
import 'package:mobiledfa/Scheduling/schedulingcontroller.dart';

import '../Login/login.dart';
import 'dashboardscm.dart';
import 'navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class MyDrawer extends StatefulWidget {
  String name;
  String position;
  String nik;

  MyDrawer({Key key, @required this.nik, @required this.position, @required this.name}) : super(key: key);

  @override
  _MyDrawer createState() => _MyDrawer(nik: nik, position: position, name: name);
}

class _MyDrawer extends State<MyDrawer> {
  String name;
  String position;
  String nik;

  _MyDrawer({Key key, @required this.nik, @required this.position, @required this.name});

  bool loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Color darkBlue = Color(0xff071d40);

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
      /*new Timer.periodic(Duration(seconds: 300),  (Timer t) => setState((){refreshList();}));*/
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
        title: new Text('Mobile DFA',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),), 
        elevation: 0.0, 
        leading: Icon(Icons.send), 
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),
            ],
            onSelected: (int value){
              if(value == 1) {
                DefaultSch();
                DefaultTask();
                DefaultGen();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginPage()));
              }},
          ),
        ],
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue])
          ),
        ),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        key: refreshKey,
        child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                child: Row(
                    children: <Widget>[
                      Text("Hi, ", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),),
                      Text("${widget.name}", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: darkBlue,
                      ),),
                    ]
                ),
              ),
              list.length > 0 ? Column(
                children: [
                  for ( var i in list )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: new Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child:Column(
                          children: <Widget>[
                            Center(
                                child: Text(i.sch_name,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),)
                            ),
                            Container(
                              height: 5,
                            ),
                            Divider(
                              height: 10,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                MaterialButton(
                                  elevation: 1.0,
                                  highlightElevation: 1.0,
                                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Sequence(nik: nik, scheduling: i.sch_name, namaSopir: i.driver_name)),); },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Icon(Icons.format_list_numbered, size: 20, color: Colors.blue,),
                                    ],
                                  ),
                                ),
                                Container(width: 10,),
                                MaterialButton(
                                  elevation: 1.0,
                                  highlightElevation: 1.0,
                                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Task(nik: nik, scheduling: i.sch_name)),); },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.library_books, size: 20, color: Colors.blue,),
                                    ],
                                  ),
                                ),
                                Container(width: 10,),
                                MaterialButton(
                                  elevation: 1.0,
                                  highlightElevation: 1.0,
                                  onPressed: () { Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Navigation(nik: nik, scheduling: i.sch_name)),); },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.location_on, size: 20, color: Colors.blue,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ) :
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Text('No Data Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
            ]
        ),
        onRefresh: refreshList,
      ),
    );
  }
}