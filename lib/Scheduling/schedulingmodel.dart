// Scheduling

class SchedulingModel {
  final double nomor;
  final String sch_name;
  final String plat_no;
  final String driver_name;
  final String nik;
  final double total_bobot;
  final double total_toko;

  bool selected = false;

  SchedulingModel({this.nomor
    , this.sch_name
    , this.plat_no
    , this.driver_name
    , this.nik
    , this.total_bobot
    , this.total_toko});

  factory SchedulingModel.fromJson(Map<String, dynamic> json) {
    return new SchedulingModel(
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      sch_name: json['sch_name'] == null ? '' : json['sch_name'],
      plat_no: json['plat_no'] == null ? '' : json['plat_no'],
      driver_name: json['driver_name'] == null ? '' : json['driver_name'],
      nik: json['nik'] == null ? '' : json['nik'],
      total_bobot: json['total_bobot'] == null ? 0 : json['total_bobot'].toDouble(),
      total_toko: json['total_toko'] == null ? 0 : json['total_toko'].toDouble(),
    );
  }
}

class SequenceModel {
  final double nomor;
  final String sch_name;
  final String plat_no;
  final String driver_name;
  final String id_toko;
  final String nama_toko;
  String urutan;
  final String lat;
  final String lng;

  bool selected = false;

  SequenceModel({this.nomor
    , this.sch_name
    , this.plat_no
    , this.driver_name
    , this.id_toko
    , this.nama_toko
    , this.urutan
    , this.lat
    , this.lng});

  factory SequenceModel.fromJson(Map<String, dynamic> json) {
    return new SequenceModel(
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      sch_name: json['sch_name'] == null ? '' : json['sch_name'],
      plat_no: json['plat_no'] == null ? '' : json['plat_no'],
      driver_name: json['driver_name'] == null ? '' : json['driver_name'],
      id_toko: json['id_toko'] == null ? '' : json['id_toko'],
      nama_toko: json['nama_toko'] == null ? '' : json['nama_toko'],
      urutan: json['urutan'] == null ? '' : json['urutan'],
      lat: json['lat'] == null ? '' : json['lat'],
      lng: json['lng'] == null ? '' : json['lng'],
    );
  }
}