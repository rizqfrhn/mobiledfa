class TaskModel {
  final double nomor;
  final String sch_name;
  final String plat_no;
  final String driver_name;
  final String id_toko;
  final String nama_toko;
  final String urutan;
  final String lat;
  final String lng;

  bool selected = false;

  TaskModel({this.nomor
    , this.sch_name
    , this.plat_no
    , this.driver_name
    , this.id_toko
    , this.nama_toko
    , this.urutan
    , this.lat
    , this.lng});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return new TaskModel(
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

class DocumentModel {
  final double nomor;
  final String sch_name;
  final String plat_no;
  final String driver_name;
  final String id_toko;
  final String nama_toko;
  final String no_doc;

  DocumentModel({this.nomor
    , this.sch_name
    , this.plat_no
    , this.driver_name
    , this.id_toko
    , this.nama_toko
    , this.no_doc});

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return new DocumentModel(
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      sch_name: json['sch_name'] == null ? '' : json['sch_name'],
      plat_no: json['plat_no'] == null ? '' : json['plat_no'],
      driver_name: json['driver_name'] == null ? '' : json['driver_name'],
      id_toko: json['id_toko'] == null ? '' : json['id_toko'],
      nama_toko: json['nama_toko'] == null ? '' : json['nama_toko'],
      no_doc: json['no_doc'] == null ? '' : json['no_doc'],
    );
  }
}

class SKUModel {
  double nomor;
  String sch_name;
  String plat_no;
  String driver_name;
  String id_toko;
  String nama_toko;
  String no_doc;
  String nama_barang;
  double qty_doc;
  double qty_act;
  String reasson;

  SKUModel({this.nomor
    , this.sch_name
    , this.plat_no
    , this.driver_name
    , this.id_toko
    , this.nama_toko
    , this.no_doc
    , this.nama_barang
    , this.qty_doc
    , this.qty_act
    , this.reasson});

  factory SKUModel.fromJson(Map<String, dynamic> json) {
    return new SKUModel(
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      sch_name: json['sch_name'] == null ? '' : json['sch_name'],
      plat_no: json['plat_no'] == null ? '' : json['plat_no'],
      driver_name: json['driver_name'] == null ? '' : json['driver_name'],
      id_toko: json['id_toko'] == null ? '' : json['id_toko'],
      nama_toko: json['nama_toko'] == null ? '' : json['nama_toko'],
      no_doc: json['no_doc'] == null ? '' : json['no_doc'],
      nama_barang: json['nama_barang'] == null ? '' : json['nama_barang'],
      qty_doc: json['qty_doc'] == null ? '' : json['qty_doc'],
      qty_act: json['qty_act'] == null ? '' : json['qty_act'],
      reasson: json['reasson'] == null ? '' : json['reasson'],
    );
  }

  Map toMap() => {
    "sch_name": sch_name,
    "driver_name": driver_name,
    "id_toko": id_toko,
    "no_doc": no_doc,
    "nama_barang": nama_barang,
    "qty_doc": qty_doc,
    "qty_act": qty_act,
    "reasson": reasson,
  };
}