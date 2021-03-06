import 'taskmodel.dart';
import 'taskcontroller.dart';
import '../Services/services.dart';
import '../Services/dbhelper.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';

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
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int _sortColumnIndex;
  bool _sortAscending = true;
  DBHelper dbHelper;
  List<SKUModel> skuDetail = [];

  void sort<T>(Comparable<T> getField(SKUModel d), bool ascending) {
    skuDetail.sort((SKUModel a, SKUModel b) {
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
      dbHelper = DBHelper();
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
    List<SKUModel> _results = await dbHelper.getSKU(scheduling, buktiDokumen);
    if (_results.length > 0)
    {
      skuDetail = await dbHelper.getSKU(scheduling, buktiDokumen);
    } else {
      setState(() {
        fetchDataSKU(scheduling, buktiDokumen);
        for (var i in listSKU) {
          SKUModel item = SKUModel(
            sch_name: scheduling.toString(),
            driver_name: i.driver_name.toString(),
            id_toko: i.id_toko.toString(),
            no_doc: buktiDokumen.toString(),
            nama_barang : i.nama_barang.toString(),
            qty_doc : i.qty_doc.toInt(),
            qty_act : i.qty_act.toInt(),
            reasson : i.reasson.toString(),
          );
          dbHelper.save(item);
        }
      });
      skuDetail = await dbHelper.getSKU(scheduling, buktiDokumen);
    }
    loading = false;

    return null;
  }

  updateSeq() async {
    setState(() {
      for (var i in skuDetail) {
        SKUModel item = SKUModel(
          sch_name: scheduling.toString(),
          driver_name: i.driver_name.toString(),
          id_toko: i.id_toko.toString(),
          no_doc: buktiDokumen.toString(),
          nama_barang : i.nama_barang.toString(),
          qty_doc : i.qty_doc.toInt(),
          qty_act : i.qty_act.toInt(),
          reasson : i.reasson.toString(),
        );
        dbHelper.update(item);
      }
      Flushbar(
        icon: Icon(Icons.check_circle_outline, color: Colors.green),
        message: 'Success!',
        duration: Duration(seconds: 3),
      )..show(context);
    });
    refreshList();
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
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              children: <Widget>[
                dataSKU(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*btnUpload(),
                    SizedBox(width: 10.0),*/
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
        columnSpacing: 10,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
              label: Text("Barang"),
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
            label: Text("Terima"),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<num>(
                        (SKUModel d) => d.qty_act, columnIndex,
                    ascending),),
          DataColumn(
            label: Text("Remarks"),
            numeric: false,
            onSort: (int columnIndex, bool ascending) =>
                _sort<String>(
                        (SKUModel d) => d.reasson, columnIndex,
                    ascending),),
        ],
        rows: skuDetail
            .map(
              (listsku) => DataRow(
            /*selected: selectedUsers.contains(user),
              onSelectChanged: (b) {
                print("Onselect");
                onSelectedRow(b, user);
              },*/
              cells: [
                DataCell(
                  Container(child: Text('${listsku.nama_barang}')
                      , width: MediaQuery.of(context).size.width * 0.25),
                ),
                DataCell(
                  Container(child: Text('${listsku.qty_doc}')
                      , margin: EdgeInsets.only(left: 5.0)
                      , width: MediaQuery.of(context).size.width * 0.15),
                ),
                DataCell(
                  Container(
                      child: TextFormField(
                        initialValue: listsku.qty_act.toString(),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            listsku.qty_act = int.parse(value);
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Qty',
                            border: InputBorder.none
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.15
                  ),
                ),
                DataCell(
                  Container(
                    child: TextFormField(
                      maxLines: null,
                      initialValue: listsku.reasson,
                      onChanged: (value){
                        setState(() {
                          listsku.reasson = value;
                        });
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          hintText: 'Add a Remark',
                          border: InputBorder.none
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.25 ,
                  ),
                ),
              ])
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
            updateSeq();
            loading = true;
          });
          loading = false;
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
          String jsonDetail = jsonEncode(skuDetail);
          print(jsonDetail);
          loading = false;
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