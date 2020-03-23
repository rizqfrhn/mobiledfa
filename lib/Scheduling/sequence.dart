import 'schedulingmodel.dart';
import 'schedulingcontroller.dart';
import '../Services/services.dart';
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
var dateFormat = new DateFormat("dd").format(now);
var monthFormat = new DateFormat("MMMM").format(now);
var yearFormat = new DateFormat("yyyy").format(now);

class Sequence extends StatefulWidget {
  String nik;
  String namaSopir;
  String scheduling;

  Sequence({Key key, @required this.nik, @required this.namaSopir, @required this.scheduling}) : super(key: key);

  @override
  _Sequence createState() => _Sequence(nik: nik, namaSopir: namaSopir, scheduling: scheduling);
}

class _Sequence extends State<Sequence> {
  String nik;
  String namaSopir;
  String scheduling;

  _Sequence({Key key, @required this.nik, @required this.namaSopir, @required this.scheduling});

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int _sortColumnIndex;
  bool _sortAscending = true;

  void sort<T>(Comparable<T> getField(SequenceModel d), bool ascending) {
    listSeq.sort((SequenceModel a, SequenceModel b) {
      if (!ascending) {
        final SequenceModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
  }

  void _sort<T>(Comparable<T> getField(SequenceModel d), int columnIndex,
      bool ascending) {
    sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  saveSeq(String json) async {
    Map dataJson = {
      'myjson': json
    };
    var response = await http.post('${url}/updateSchedulingSopirOrange?', body: dataJson);
    if(response.statusCode == 200) {
      setState(() {
        loading = false;
        Flushbar(
          icon: Icon(Icons.check_circle_outline, color: Colors.green),
          message: 'Success!',
          duration: Duration(seconds: 3),
        )..show(context);
      });
    } else {
      setState(() {
        loading = false;
        Flushbar(
          icon: Icon(Icons.highlight_off, color: Colors.red),
          message: 'Failed!',
          duration: Duration(seconds: 3),
        )..show(context);
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
      fetchDataSeq(scheduling);
      loading = false;
    });

    return null;
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
        child: Form(
          key: _formKey,
          child: Scrollbar(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              children: <Widget>[
                dataSopir(),
                SizedBox(height: 10.0),
                dataToko(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    btnUpload(),
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

  Widget dataSopir() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Nama',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text('Tanggal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
              ],
            ),
            SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(':',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(':',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
              ],
            ),
            SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${namaSopir}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text('${dateFormat} ${monthFormat} ${yearFormat}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
              ],
            ),
          ],
      ),
    );
  }

  Widget dataToko() {
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
              label: Text("Toko"),
              numeric: false,
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>(
                          (SequenceModel d) => d.nama_toko, columnIndex,
                      ascending),),
          DataColumn(
            label: Text("Urutan"),
            numeric: false,
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>(
                          (SequenceModel d) => d.urutan, columnIndex,
                      ascending),),
        ],
        rows: listSeq
            .map(
              (listseq) => DataRow(
              /*selected: selectedUsers.contains(user),
              onSelectChanged: (b) {
                print("Onselect");
                onSelectedRow(b, user);
              },*/
              cells: [
                DataCell(
                  Container(child: Text('${listseq.nama_toko}'), width: MediaQuery.of(context).size.width * 0.5),
                ),
                DataCell(
                  Container(
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value == "0") {
                            return 'Urutan harus diisi atau belum sesuai!';
                          }
                          return null;
                        },
                        initialValue: listseq.urutan,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            listseq.urutan = value;
                            /*updateSeq(listdetail);*/
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Sequence',
                            border: InputBorder.none
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3
                  ),
                ),
              ]),
        ).toList(),
      ),
    );
  }

  Widget btnUpload() {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.3,
      /*padding: EdgeInsets.symmetric(horizontal: 5.0),*/
      child: RaisedButton(
        onPressed: () {
          setState(() {
            if (_formKey.currentState.validate()) {
              // If the form is valid.
              String jsonDetail = jsonEncode(listSeq);
              saveSeq(jsonDetail);
            }
          });
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