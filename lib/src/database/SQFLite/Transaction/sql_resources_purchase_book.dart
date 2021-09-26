import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_db_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:sqflite/sqflite.dart';

class PurchaseBookSQLResources {
  Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await PurchaseBookSqlDB.database;

    return await db.insert(
      PurchaseBookSqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  Future<List<PurchaseBookModel>> getListModel() async {
    var listMaps = await getEntries();
    return listMaps
        .map(
          (map) => PurchaseBookModel.fromJSON(map),
        )
        .toList();
  }

  getPath() async {
    final db = await PurchaseBookSqlDB.database;

    print(db.path);
  }

  clearDb() async {
    final db = await PurchaseBookSqlDB.database;
    var val = await db.delete(
      PurchaseBookSqlDB.table,
    );
    print(val);
  }

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

  static Future<List<PurchaseBookModel>> convertMapIntoModels(
    List<Map<String, dynamic>> listMaps,
  ) async {
    return listMaps.map((map) => PurchaseBookModel.fromJSON(map)).toList();
  }
}

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
}
