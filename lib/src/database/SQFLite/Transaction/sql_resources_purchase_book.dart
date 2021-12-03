import 'package:mandimarket/src/database/SQFLite/Transaction/sql_db_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:sqflite/sqflite.dart';

class PurchaseBookSQLResources {
//
//  ------------------ INSERT ------------------------------------------------

  Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await PurchaseBookSqlDB.database;

    return await db.insert(
      PurchaseBookSqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ------------------- GET -----------------------------------------------------

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await PurchaseBookSqlDB.database;

    var listMap = await db.rawQuery(
      '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        ORDER BY bepariName COLLATE NOCASE''',
    );

    print(listMap);

    return listMap;
  }

// ----------------- SINGLE ENTRIES --------------------------------------------

  Future<List<Map<String, dynamic>>> getEntriesFromPurchaseBookByDate(
    DateTime date,
  ) async {
    final db = await PurchaseBookSqlDB.database;

    var listMap = await db.rawQuery(
      '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        WHERE selectedTimestamp == '${formatDate(date)}'
        ORDER BY bepariName COLLATE NOCASE''',
    );

    return listMap;
  }

// --------------------- GET MODEL ---------------------------------------------

  Future<List<PurchaseBookModel>> getListModel() async {
    var listMaps = await getEntries();
    return listMaps
        .map(
          (map) => PurchaseBookModel.fromJSON(map),
        )
        .toList();
  }

// --------------------- GET PATH ----------------------------------------------
  getPath() async {
    final db = await PurchaseBookSqlDB.database;

    print(db.path);
  }

// ---------------------- CLEAR DB ---------------------------------------------

  clearDb() async {
    final db = await PurchaseBookSqlDB.database;
    var val = await db.delete(
      PurchaseBookSqlDB.table,
    );
    print(val);
  }

// --------------------- GET ENTRIES USING DATE HASH ----------------------------

  static Future<List<Map<String, dynamic>>> getEntriesUsingDateHash({
    required int fromDateHash,
    required int toDateHash,
  }) async {
    final db = await PurchaseBookSqlDB.database;

    var listMap = await db.rawQuery(
      '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        WHERE dateHash >= $fromDateHash
        AND dateHash <= $toDateHash''',
    );

    print(listMap);
    return listMap;
  }

// --------------------- CONVERT MAP INTO MODELS -------------------------------

  static Future<List<PurchaseBookModel>> convertMapIntoModels(
    List<Map<String, dynamic>> listMaps,
  ) async {
    return listMaps.map((map) => PurchaseBookModel.fromJSON(map)).toList();
  }

  static Future<List<Map<String, dynamic>>> getDates() async {
    final db = await PurchaseBookSqlDB.database;

    final listMap = db.rawQuery(
      '''
        SELECT dateHash, selectedTimestamp
        FROM ${PurchaseBookSqlDB.table} 
        GROUP BY dateHash, selectedTimestamp
      ''',
    );

    return listMap;
  }

// ----------------------- Bepari name from Dates ------------------------------

  static Future<List<Map<String, dynamic>>> getParamsForBillingEntry({
    required int dateHash,
  }) async {
    final db = await PurchaseBookSqlDB.database;

    return db.rawQuery(
      '''
        SELECT bepariName, unit, kacchiRakam, discount
        FROM ${PurchaseBookSqlDB.table}
        WHERE dateHash == $dateHash
      ''',
    );
  }

// -------------- Params for Billing Entry -------------------------------------

  // static Future<List<Map<String, dynamic>>> getParamsForBillingEntry({
  //   required String bepariName,
  //   required int dateHash,
  // }) async {
  //   final db = await PurchaseBookSqlDB.database;

  //   return db.rawQuery(
  //     '''
  //       SELECT bepariName, unit, kacchiRakam, discount
  //       FROM ${PurchaseBookSqlDB.table}
  //       WHERE dateHash == $dateHash
  //       AND bepariName == "$bepariName"
  //     ''',
  //   );
  // }

// -----------------------------------------------------------------------------

}

// ===================== HELPER QUERIES ==============================================================================================
class _HelperQueries {
  castStringAsIntegerAndCompareThem() {
    String val = '12';
    String val1 = '13';
    var castStringAsInteger = '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        WHERE selectedTimestamp >= CAST($val AS INTEGER)
        AND selectedTimestamp <= CAST($val1 AS INTEGER)''';
  }

  orderByAndConvertIntoLowerCase() {
    var orderByAndConvertIntoLowerCase = '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        ORDER BY bepariName COLLATE NOCASE''';

    // For descending order -> NOCASE DESC
  }

  createANewTableAfterDBHasCreated() {
    var alterTable = '''
      ALTER TABLE tableName
      ADD COLUMN colName TEXT
      ''';
  }
}
