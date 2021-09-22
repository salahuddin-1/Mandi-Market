import 'package:mandimarket/src/database/SQFLite/Master/sql_db_master.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:sqflite/sqflite.dart';

class MasterSqlResources {
  Future<int> insertEntry({
    required Map<String, dynamic> map,
    required String type,
  }) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.insert(
      type.toLowerCase(),
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEntries(String type) async {
    type = type.toLowerCase();
    Map<String, Database> dbs = await MasterSqlDB.databases;

    var listMap = await dbs[type]!.query(type);

    print(listMap);

    return await dbs[type]!.query(type);
  }

  Future<List<MasterModel>> getListsOfModel(String type) async {
    var listmap = await getEntries(type);

    return listmap.map((map) => MasterModel.fromJSON(map)).toList();
  }

  clearDb(String type) async {
    type = type.toLowerCase();

    final db = await MasterSqlDB.databases;
    var val = await db[type]!.delete(type);
    print(val);
  }
}
