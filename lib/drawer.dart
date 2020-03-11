import 'package:mobiledfa/Scheduling/schedulingcontroller.dart';
import 'package:mobiledfa/Scheduling/schedulingmodel.dart';
import 'package:mobiledfa/Task/taskcontroller.dart';

import 'Login/login.dart';
import 'package:mobiledfa/Scheduling/scheduling.dart';
import 'General/dashboardscm.dart';
import 'General/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title,this.icon);
}

class MyDrawer extends StatefulWidget {
  String name;
  String position;
  String nik;

  MyDrawer(
      {Key key, @required this.name, @required this.position, @required this.nik})
      : super(key: key);

  final drawerItem = [
    new DrawerItem("Scheduling", Icons.schedule),
    new DrawerItem("Task", Icons.play_circle_filled),
    new DrawerItem("Navigation", Icons.public),
  ];

  @override
  _MyDrawer createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  Color darkBlue = Color(0xff071d40);
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Scheduling(nik: widget.nik);
      case 1:
        return DashboardSCM(nik: widget.nik, periode: '', lokasi: '');
      case 2:
        return Navigation(nik: widget.nik, periode: '', lokasi: '');

    default:
    return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Mobile DFA',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          elevation: 0.0,
          leading: /*Container()*/Icon(Icons.send),
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
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginPage()));
                }
              },
            ),
          ],
          flexibleSpace: new Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue])
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            /*ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor
                ),
                height: 200,
              ),
            ),*/
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
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
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0
                      ),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: widget.drawerItem.length,
                      )
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    DrawerItem draweritem = widget.drawerItem[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () { Navigator.push(context, MaterialPageRoute(
          builder: (context) => _getDrawerItemWidget(index)),); },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if(draweritem.icon != null)
            Icon(draweritem.icon, size: 80,),
          if(draweritem.icon != null)
            SizedBox(height: 10.0),
          Text(
            draweritem.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}