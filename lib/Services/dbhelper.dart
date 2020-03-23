import 'dart:async';
import 'dart:io' as io;
import 'package:mobiledfa/Task/taskmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'SKUDetail.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE SKUDetail ('
        'sch_name STRING, '
        'driver_name STRING, '
        'id_toko STRING, '
        'no_doc STRING, '
        'nama_barang STRING, '
        'qty_doc INTEGER, '
        'qty_act INTEGER, '
        'reasson STRING)');
  }

  Future<int> save(SKUModel skuDetail) async {
    var dbClient = await db;
    var result = await dbClient.insert('SKUDetail', skuDetail.toMap());
    return result;
  }

  Future<List<SKUModel>> getSKU(String scheduling, String buktiDokumen) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('SKUDetail',
        columns: ['sch_name', 'driver_name', 'id_toko', 'no_doc', 'nama_barang', 'qty_doc', 'qty_act', 'reasson'],
        where: 'sch_name = ? AND no_doc = ?',
        whereArgs: [scheduling, buktiDokumen]);
    List<SKUModel> skuDetail = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        skuDetail.add(SKUModel.fromJson(maps[i]));
      }
    }
    return skuDetail;
  }

  /*Future<int> delete(String schName) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM SKUDetail WHERE sch_name = $schName');
  }*/

  Future<int> update(SKUModel skuDetail) async {
    var dbClient = await db;
    return await dbClient.rawUpdate(
        'UPDATE SKUDetail SET qty_act = ${skuDetail.qty_act}, reasson = ${skuDetail.reasson} '
            'WHERE sch_name = ${skuDetail.sch_name} AND nama_toko = ${skuDetail.nama_toko} '
            'AND no_doc = ${skuDetail.no_doc} AND driver_name = ${skuDetail.driver_name}'
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}