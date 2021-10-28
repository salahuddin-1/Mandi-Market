import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_db_billing_entry.dart';
import 'package:sqflite/sqflite.dart';

class BillingEntriesSQLResources {
// ------------------- INSERT --------------------------------------------------

  static Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await BillingEntrySqlDB.database;

    return await db.insert(
      BillingEntrySqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ----------------------- UPDATE ENTRY ----------------------------------------------

  static Future<int> updateEntry({
    required Map<String, dynamic> map,
    required int documentId,
  }) async {
    final db = await BillingEntrySqlDB.database;

    return await db.update(
      BillingEntrySqlDB.table,
      map,
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
  }

// ------------------- DELETE ENTRY --------------------------------------------

  static Future<int> deleteEntry(int documentId) async {
    final db = await BillingEntrySqlDB.database;

    return await db.delete(
      BillingEntrySqlDB.table,
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
  }

//  -----------------  GET ENTRIES  --------------------------------------------

  static Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await BillingEntrySqlDB.database;

    var listMap = await db.rawQuery(
      '''SELECT *
        FROM ${BillingEntrySqlDB.table}
        ORDER BY bepariName COLLATE NOCASE''',
    );

    print(listMap);

    return listMap;
  }

// ------------------- GET ENTRIES BY DATE -------------------------------------
  static Future<List<Map<String, dynamic>>> getEntriesByDate(
    DateTime date,
  ) async {
    final db = await BillingEntrySqlDB.database;

    return await db.rawQuery(
      '''
      SELECT * 
      FROM ${BillingEntrySqlDB.table}
      WHERE dateHash == ${calculateDateHash(date)}
      ORDER BY bepariName COLLATE NOCASE
      ''',
    );
  }

  static Future<List<Map<String, dynamic>>> getEntriesByDocId(int docId) async {
    final db = await BillingEntrySqlDB.database;

    return await db.rawQuery(
      '''
      SELECT *
      FROM ${BillingEntrySqlDB.table}
      WHERE documentId == $docId
      ''',
    );
  }

// ---------------------- DELETE ALL -------------------------------------------
  static deleteAllBillingEntries() async {
    final db = await BillingEntrySqlDB.database;
    int result = await db.delete(BillingEntrySqlDB.table);
    print(result);
  }

// -----------------------------------------------------------------------------
}
