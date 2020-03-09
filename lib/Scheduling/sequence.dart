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

class Task extends StatefulWidget {
  String nik;

  Task({Key key, @required this.nik}) : super(key: key);

  @override
  _Task createState() => _Task(nik: nik);
}

class _Task extends State<Task> {
  String nik;

  _Task({Key key, @required this.nik});

  AnimationController _animationController;
  OmsetDataSource _omsetDataSource = OmsetDataSource([], null, null, null);
  bool loading = false;
  bool firstload;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  PeriodeModel periodeSelection;
  String periode = 'O${year}${month}';
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  bool isLoaded = false;
  Color darkBlue = Color(0xff071d40);
  Icon actionIcon = new Icon(Icons.search);

  Future<void> _fetchData(String periode) async {
    final result = await fetchResultOmset(http.Client(), nik, periode);
    if (!loading) {
      setState(() {
        _omsetDataSource = OmsetDataSource(result, nik, periode, context);
      });
    }
  }

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
      periodeSelection = null;
    });

  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loading = false;
    });

    return null;
  }

  void _sort<T>(Comparable<T> getField(OmsetModel d), int columnIndex,
      bool ascending) {
    _omsetDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Sequence',
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
                    new Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Nama',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text('Tanggal',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text('Rute',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: <Widget>[
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: <Widget>[
                            Text('${''}',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text('${''}',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                            Text('${''}',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0),
                          ],
                        )
                      ],
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

  Widget dataToko() {
    return PaginatedDataTable(
      rowsPerPage: _rowsPerPage,
      onRowsPerPageChanged: (int value) {
        setState(() {
          _rowsPerPage = value;
        });
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      dataRowHeight: 45.0,
      columnSpacing: 15.0,
      horizontalMargin: 15.0,
      columns: <DataColumn>[
        DataColumn(
          label: Text('Toko'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<String>(
                      (OmsetModel d) => d.nama_regional, columnIndex,
                  ascending),
        ),
        DataColumn(
          label: Text('Urutan'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.persentase_harian,
                  columnIndex, ascending),
        ),
      ],
      source: _omsetDataSource,
    );
  }
}