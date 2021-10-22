import '/src/database/SQFLite/Master/sql_db_master.dart';
import '/src/ui/Master1/master_model.dart';
import 'package:sqflite/sqflite.dart';

class MasterSqlResources {
//
// ----------------- INSERT ENTRY ----------------------------------------------

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

// ------------------ GET ENTRIES ----------------------------------------------

  Future<List<Map<String, dynamic>>> getEntries(String type) async {
    Map<String, Database> dbs = await MasterSqlDB.databases;

    return await dbs[type]!.rawQuery(
      '''SELECT *
        FROM $type
        ORDER BY partyName COLLATE NOCASE''',
    );
  }

// ------------------- GET ENTRIES FOR EDITING ---------------------------------

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

// --------------------- UPDATE ENTRY ------------------------------------------

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

// --------------------------- DELETE ENTRY ------------------------------------

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

// ----------------------- GET LISTS OF MODEL -----------------------------------

  Future<List<MasterModel>> getListsOfModel(String type) async {
    var listmap = await getEntries(type);

    return listmap.map((map) => MasterModel.fromJSON(map)).toList();
  }

// ------------------------ CLEAR DB ------------------------------------------

  clearDb(String type) async {
    final db = await MasterSqlDB.databases;
    var val = await db[type]!.delete(type);
    print(val);
  }

// ------------------------ GET USER BY NAME -----------------------------------

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

// -----------------------------------------------------------------------------
}
