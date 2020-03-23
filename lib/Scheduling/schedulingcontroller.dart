import 'schedulingmodel.dart';
import '../Services/services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FlutterMoneyFormatter {
  FlutterMoneyFormatter({@required this.amount,}){}

  double amount;

  String get compact {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return 'Rp. $compacted';
  }
  String get compactNonSymbol {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return '$compacted';
  }
}
List<SequenceModel> listSeq = [];
/*List<SchedulingDetailModel> listSequence = [];*/
bool loading = false;
var refreshKey = GlobalKey<RefreshIndicatorState>();
var now = new DateTime.now();
int monthChart = now.month;
int yearChart = now.year;

DefaultSch() {
  listSeq.clear();
}

//SEQUENCE

fetchDataSeq(String scheduling) async {
  Map dataSeq = {
    'scheduling': scheduling
  };

  var responseSeq =
  await http.post(
      '${url}/GetDetailDFAListToko?',
      body: dataSeq);
  if (responseSeq.statusCode == 200) {
    listSeq = (json.decode(responseSeq.body)['Table'] as List)
        .map((data) => new SequenceModel.fromJson(data))
        .toList();
  }
}

/*
Future<List<SchedulingSeqModel>> fetchResultScheduling(http.Client client, String nik, String scheduling) async {
  Map data = {
    'nik': nik,
    'scheduling': scheduling
  };

  final response =
  await client.post('${url}/GetDetailDFA?', body: data);

  return compute(parseScheduling, response.body);
}

List<SchedulingSeqModel> parseScheduling(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed.map<SchedulingSeqModel>((json) => SchedulingSeqModel.fromJson(json)).toList();
}

class SchedulingDataSource extends DataTableSource {
  final String nik;
  final String scheduling;
  final List<SchedulingSeqModel> _items;
  final BuildContext context;
  SchedulingDataSource(this._items, this.nik, this.scheduling, this.context);
  final TextEditingController seqController = new TextEditingController();

  void sort<T>(Comparable<T> getField(SchedulingSeqModel d), bool ascending) {
    _items.sort((SchedulingSeqModel a, SchedulingSeqModel b) {
      if (!ascending) {
        final SchedulingSeqModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length)
      return null;
    final SchedulingSeqModel scheduling = _items[index];
    return DataRow.byIndex(
      index: index,
      */
/*selected: scheduling.selected,
      onSelectChanged: (bool value) {
        if (scheduling.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          scheduling.selected = value;
          notifyListeners();
        }
      },*//*

      cells: <DataCell>[
        DataCell(Container(child: Text('${scheduling.nama_toko}'), width: MediaQuery.of(context).size.width * 0.38), */
/*onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SchedulingArea(nama_regional: scheduling.nama_regional, nik: nik, periode: periode,)),
        );}*//*
),
        DataCell(Container(child: TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3),],
          keyboardType: TextInputType.number,
          onChanged: (value){
            scheduling.urutan = value;
          },
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Sequence',
            border: InputBorder.none
          ),
        ), width: MediaQuery.of(context).size.width * 0.38),),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (SchedulingSeqModel dessert in _items)
      dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}*/
