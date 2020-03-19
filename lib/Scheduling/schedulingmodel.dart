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

  Map toJson() => {
    'sch_name': sch_name,
    'id_toko': id_toko,
    'urutan': urutan,
  };
}