import 'package:mobiledfa/General/generalmodel.dart';
import 'package:mobiledfa/General/generalcontroller.dart';
import '../services.dart';
import 'generalcontroller.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

CameraPosition tokoPosition = CameraPosition(target: LatLng(double.parse(listLatLng[0].lat), double.parse(listLatLng[0].lng)), zoom: 10.3);
CameraPosition firstPosition = CameraPosition(target: LatLng(-6.8806557,107.5906915), zoom: 13);

class Navigation extends StatefulWidget {
  String nik;
  String scheduling;

  Navigation({Key key, @required this.nik, this.scheduling}) : super(key: key);

  @override
  _Navigation createState() => new _Navigation();
}

class _Navigation extends State<Navigation> {
  Completer<GoogleMapController> _controller = Completer();

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    setState(() {
      _markers.clear();
      for (final latlng in listLatLng) {
        Marker marker = Marker(
          markerId: MarkerId(latlng.nama_toko),
          position: LatLng(double.parse(latlng.lat), double.parse(latlng.lng)),
          infoWindow: InfoWindow(
            title: latlng.nama_toko,
            /*snippet: latlng.urutan,*/
          ),
        );
        _markers[latlng.nama_toko] = marker;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fetchDataLatLng(widget.scheduling);
      new Timer.periodic(Duration(seconds: 3),  (Timer firstTime) =>
          setState((){
            _goToToko();
            firstTime.cancel();
          })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Navigation',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue])
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: firstPosition,
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }

  Future<void> _goToToko() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(tokoPosition));
  }
}
