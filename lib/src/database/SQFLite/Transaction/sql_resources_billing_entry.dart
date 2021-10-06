import 'package:mandimarket/src/database/SQFLite/Transaction/sql_db_billing_entry.dart';
import 'package:sqflite/sqflite.dart';

class BillingEntriesSQLResources {
  // INSERT
  static Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await BillingEntrySqlDB.database;

    return await db.insert(
      BillingEntrySqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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
}
