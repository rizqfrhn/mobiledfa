import 'dart:async';
import 'dart:io';
import 'package:mobiledfa/Task/taskmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Database db;

class DBHelper {
  void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult, List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('SKUDetail.db');
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(db);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE SKUDetail ('
        'sch_name TEXT, '
        'driver_name TEXT, '
        'id_toko TEXT, '
        'no_doc TEXT, '
        'nama_barang TEXT, '
        'qty_doc INTEGER, '
        'qty_act INTEGER, '
        'reasson TEXT)');
  }

  Future<void> save(SKUModel skuDetail) async {
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
    /*final sql = '''SELECT * FROM SKUDetail
    WHERE sch_name = ${scheduling} AND no_doc = ${buktiDokumen}''';
    final data = await db.rawQuery(sql);
    List<SKUModel> skuDetail = [];
    for (final node in data) {
      final todo = SKUModel.fromJson(node);
      skuDetail.add(todo);
    }
    return skuDetail;*/
  }

  /*Future<int> delete(String schName) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM SKUDetail WHERE sch_name = $schName');
  }*/

  Future<void> update(SKUModel skuDetail) async {
    var dbClient = await db;
    return await dbClient.update(
      'SKUDetail',
      skuDetail.toMap(),
      where: 'sch_name = ? AND id_toko = ? AND no_doc = ? AND nama_barang = ?',
      whereArgs: [skuDetail.sch_name, skuDetail.id_toko, skuDetail.no_doc, skuDetail.nama_barang],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}