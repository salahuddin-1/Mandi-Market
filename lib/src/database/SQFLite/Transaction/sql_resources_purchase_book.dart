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

    return await db.rawQuery(
      '''SELECT *
        FROM ${PurchaseBookSqlDB.table}
        ORDER BY bepariName COLLATE NOCASE''',
    );

    // For descending order -> NOCASE DESC
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
}
