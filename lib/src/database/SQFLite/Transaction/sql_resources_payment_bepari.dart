import 'package:mandimarket/src/database/SQFLite/Transaction/sql_db_payment_bepari.dart';
import 'package:sqflite/sqflite.dart';

class PaymentBepariSQLResources {
// ------------------- INSERT --------------------------------------------------

  static Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await PaymentBepariSqlDB.database;

    return await db.insert(
      PaymentBepariSqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ---------------------- UPDATE BILL-----------------------------------------------

  static Future<int> updateEntry(
    Map<String, dynamic> map, {
    required String bepariName,
  }) async {
    final db = await PaymentBepariSqlDB.database;

    return await db.update(
      PaymentBepariSqlDB.table,
      map,
      where: "bepariName = ?",
      whereArgs: [bepariName],
    );
  }

// ------------------- GET BILLS -----------------------------------------------

  static Future<List<Map<String, dynamic>>> getAllBills() async {
    final db = await PaymentBepariSqlDB.database;

    return await db.rawQuery(
      '''
        SELECT *
        FROM ${PaymentBepariSqlDB.table}
      ''',
    );
  }

// -----------------------------------------------------------------------------

  static Future<Map<String, dynamic>?> getBills(String bepariName) async {
    final db = await PaymentBepariSqlDB.database;

    final listMap = await db.rawQuery(
      '''
        SELECT bills, pendingAmount, paidAmount
        FROM ${PaymentBepariSqlDB.table}
        WHERE bepariName == "$bepariName"
      ''',
    );

    if (listMap.isEmpty) return null;

    return listMap[0];
  }

// ------------------------ GET BILL BY BEPARI NAME ----------------------------
  static Future<Map<String, dynamic>?> getBillByBepariName(
    String bepariName,
  ) async {
    final db = await PaymentBepariSqlDB.database;

    final listMap = await db.rawQuery(
      '''
        SELECT *
        FROM ${PaymentBepariSqlDB.table}
        WHERE bepariName == "$bepariName"
      ''',
    );

    if (listMap.isEmpty) return null;

    return listMap[0];
  }

// ------------------ DELETE ALL -----------------------------------------------

  static Future<int> deleteAll() async {
    final db = await PaymentBepariSqlDB.database;
    return await db.delete(
      PaymentBepariSqlDB.table,
    );
  }

// -----------------------------------------------------------------------------
}
