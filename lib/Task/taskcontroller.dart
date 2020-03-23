import 'taskmodel.dart';
import '../Services/services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

List<TaskModel> listTask = [];
List<DocumentModel> listDocument = [];
List<SKUModel> listSKU = [];
bool loading = false;
var refreshKey = GlobalKey<RefreshIndicatorState>();
var now = new DateTime.now();
int monthChart = now.month;
int yearChart = now.year;

DefaultTask() {
  listTask.clear();
  listDocument.clear();
  listSKU.clear();
}

fetchDataTask(String scheduling) async {
  Map dataTask = {
    'scheduling': scheduling
  };

  var responseTask =
  await http.post(
      '${url}/GetDetailDFAListToko?',
      body: dataTask);
  if (responseTask.statusCode == 200) {
    listTask = (json.decode(responseTask.body)['Table'] as List)
        .map((data) => new TaskModel.fromJson(data))
        .toList();
  }
}

//DOCUMENT

fetchDataDoc(String scheduling, String toko) async {
  Map dataDoc = {
    'scheduling': scheduling,
    'toko': toko
  };

  var responseDoc =
  await http.post(
      '${url}/GetDetailDFAListDokumen?',
      body: dataDoc);
  if (responseDoc.statusCode == 200) {
    listDocument = (json.decode(responseDoc.body)['Table'] as List)
        .map((data) => new DocumentModel.fromJson(data))
        .toList();
  }
}

//SKU

fetchDataSKU(String scheduling, String buktiDokumen) async {
  Map dataSKU = {
    'scheduling': scheduling,
    'buktiDokumen': buktiDokumen
  };

  var responseSKU =
  await http.post(
      '${url}/GetDetailDFAListSku?',
      body: dataSKU);
  if (responseSKU.statusCode == 200) {
    listSKU = (json.decode(responseSKU.body)['Table'] as List)
        .map((data) => new SKUModel.fromJson(data))
        .toList();
  }
}