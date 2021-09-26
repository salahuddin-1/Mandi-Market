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
      type,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEntries(String type) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.rawQuery(
      '''SELECT *
        FROM $type
        ORDER BY partyName COLLATE NOCASE''',
    );
  }

  Future<List<Map<String, dynamic>>> getEntriesForEditing({
    required String type,
    required String docId,
  }) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.query(
      type,
      where: 'documentId = ?',
      whereArgs: [docId],
    );
  }

  Future<int> updateEntry({
    required String type,
    required int docId,
    required Map<String, dynamic> map,
  }) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.update(
      type,
      map,
      where: 'documentId = ?',
      whereArgs: [docId],
    );
  }

  Future<int> deleteEntry({
    required String type,
    required int docId,
  }) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.delete(
      type,
      where: 'documentId = ?',
      whereArgs: [docId],
    );
  }

  Future<List<MasterModel>> getListsOfModel(String type) async {
    var listmap = await getEntries(type);

    return listmap.map((map) => MasterModel.fromJSON(map)).toList();
  }

  clearDb(String type) async {
    final db = await MasterSqlDB.databases;
    var val = await db[type]!.delete(type);
    print(val);
  }

  static Future<bool> getUserByName(String type, String partyName) async {
    bool partyExists = false;

    Map<String, Database> dbs = await MasterSqlDB.databases;

    var listMap = await dbs[type]!.rawQuery(
      '''SELECT partyName
        FROM $type
        ORDER BY partyName COLLATE NOCASE''',
    );

    listMap.forEach(
      (map) {
        String name = map['partyName'].toString().toLowerCase();
        if (name == partyName) {
          partyExists = true;
        }
      },
    );

    return partyExists;
  }
}
