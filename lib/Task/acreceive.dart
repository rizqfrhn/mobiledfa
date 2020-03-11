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
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();
var dateFormat = new DateFormat("dd").format(now);
var monthFormat = new DateFormat("MMMM").format(now);
var yearFormat = new DateFormat("yyyy").format(now);
var monthComboBox = new DateFormat("MMMM").format(now);
var yearComboBox = new DateFormat("yyyy").format(now);
final numformat = new NumberFormat("#,###");
bool isFilter = false;

class SKUReceive extends StatefulWidget {
  String nik;
  String scheduling;
  String buktiDokumen;

  SKUReceive({Key key, @required this.nik, @required this.scheduling, @required this.buktiDokumen}) : super(key: key);

  @override
  _SKUReceive createState() => _SKUReceive(nik: nik, scheduling: scheduling, buktiDokumen: buktiDokumen);
}

class _SKUReceive extends State<SKUReceive> {
  String nik;
  String scheduling;
  String buktiDokumen;

  _SKUReceive({Key key, @required this.nik, @required this.scheduling , @required this.buktiDokumen});

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool firstload;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String periode = 'O${year}${month}';
  int _sortColumnIndex;
  bool _sortAscending = true;
  bool isLoaded = false;
  Color darkBlue = Color(0xff071d40);
  Icon actionIcon = new Icon(Icons.search);

  void sort<T>(Comparable<T> getField(SKUModel d), bool ascending) {
    listSKU.sort((SKUModel a, SKUModel b) {
      if (!ascending) {
        final SKUModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
  }

  void _sort<T>(Comparable<T> getField(SKUModel d), int columnIndex,
      bool ascending) {
    sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
      refreshList();
      new Timer.periodic(Duration(seconds: 10),  (Timer firstTime) =>
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
      fetchDataSKU(scheduling, buktiDokumen);
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Form Receive',
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
        child: Form(
          key: _formKey,
          child: Scrollbar(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                dataSKU(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    btnUpload(),
                    SizedBox(width: 10.0),
                    btnSave(),
                  ],
                )
              ],
            ),
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget dataSKU() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
              label: Text("Nama Barang"),
              numeric: false,
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>(
                          (SKUModel d) => d.nama_barang, columnIndex,
                      ascending),),
          DataColumn(
              label: Text("Kirim"),
              numeric: false,
              onSort: (int columnIndex, bool ascending) =>
                  _sort<num>(
                          (SKUModel d) => d.qty_doc, columnIndex,
                      ascending),),
          DataColumn(
            label: Text("Remarks"),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (SKUModel d) => d.reasson, columnIndex,
                    ascending),),
        ],
        rows: listSKU
            .map(
              (listsku) => DataRow(
            /*selected: selectedUsers.contains(user),
              onSelectChanged: (b) {
                print("Onselect");
                onSelectedRow(b, user);
              },*/
              cells: [
                DataCell(
                  Container(child: Text('${listsku.nama_barang}'), width: MediaQuery.of(context).size.width * 0.21),
                ),
                DataCell(
                  Container(child: Text('${listsku.qty_doc}'), width: MediaQuery.of(context).size.width * 0.15),
                ),
                DataCell(
                  Container(
                      child: TextFormField(
                        initialValue: listsku.reasson,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            listsku.reasson = value;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Add a Remark...',
                            border: InputBorder.none
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.25
                  ),
                ),
              ]),
        ).toList(),
      ),
    );
  }

  Widget btnSave() {
    return Container(
      height: 50.0,
      /*padding: EdgeInsets.symmetric(horizontal: 5.0),*/
      child: RaisedButton(
        onPressed: () {
          setState(() {
            loading = true;
          });
          /*saveSeq('');*/
        },//since this is only a UI app
        child: Text('Save',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
      ),
    );
  }

  Widget btnUpload() {
    return Container(
      height: 50.0,
      /*padding: EdgeInsets.symmetric(horizontal: 5.0),*/
      child: RaisedButton(
        onPressed: () {
          setState(() {
            loading = true;
          });
          String jsonDetail = jsonEncode(listSKU);
          print(jsonDetail);
        },//since this is only a UI app
        child: Text('Upload',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
      ),
    );
  }
}