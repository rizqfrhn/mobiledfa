import 'generalmodel.dart';
import '../services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:mobiledfa/General/navigation.dart';

List<SchedulingModel> list = [];
List<LatLngModel> listLatLng = [];
double Lat = 0, Lng = 0;

DefaultGen() {
  list.clear();
}

fetchDataSch(String nik) async {
  Map dataSch = {
    'nik': nik,
    'scheduling': ''
  };

  var responseSch =
  await http.post(
      '${url}/GetHeaderDFA?',
      body: dataSch);
  if (responseSch.statusCode == 200) {
    list = (json.decode(responseSch.body)['Table'] as List)
        .map((data) => new SchedulingModel.fromJson(data))
        .toList();
  }
}

fetchDataMap(String scheduling) async {
  Map dataMap = {
    'scheduling': scheduling
  };

  var responseMap =
  await http.post(
      '${url}/GetDetailDFAListToko?',
      body: dataMap);
  if (responseMap.statusCode == 200) {
    return MapsModel.fromJson(json.decode(responseMap.body)['Table']);
  }
}

fetchDataLatLng(String scheduling) async {
  Map dataLatLng = {
    'scheduling': scheduling
  };

  var responseLatLng =
  await http.post(
      '${url}/GetDetailDFAListToko?',
      body: dataLatLng);
  if (responseLatLng.statusCode == 200) {
    listLatLng = (json.decode(responseLatLng.body)['Table'] as List)
        .map((data) => new LatLngModel.fromJson(data))
        .toList();
  }
}