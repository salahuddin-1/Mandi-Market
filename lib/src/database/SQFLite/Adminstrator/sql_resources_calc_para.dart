import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:sqflite/sqflite.dart';

import 'sql_db_calculation_parameter.dart';

class SQLresourcesCalcPara {
  // -----------------------------------------------------------------
  static Future<int> insertEntry(Map<String, dynamic> map) async {
    final db = await CalculationParameterSqlDB.database;

    return await db.insert(
      CalculationParameterSqlDB.table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// -------------- EDIT ENTRY -----------------------------------------------
  static Future<int> editEntry({
    required Map<String, dynamic> map,
    required String documentId,
  }) async {
    final db = await CalculationParameterSqlDB.database;

    return await db.update(
      CalculationParameterSqlDB.table,
      map,
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
  }

// ------------------- DELETE ENTRY --------------------------------------------

  static Future<int> deleteEntry(String documentId) async {
    final db = await CalculationParameterSqlDB.database;

    return await db.delete(
      CalculationParameterSqlDB.table,
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
  }

// -------------------------------------------------------------------------
  static clearDb() async {
    final db = await CalculationParameterSqlDB.database;
    var val = await db.delete(
      CalculationParameterSqlDB.table,
    );
    print(val);
  }

// ------------------------------------------------------------------------
  static Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await CalculationParameterSqlDB.database;

    var listMap = await db.rawQuery(
      '''
        SELECT * 
        FROM ${CalculationParameterSqlDB.table}
        ORDER BY timestamp DESC
      ''',
    );

    print(listMap);

    return listMap;
  }

// ---------------- GET ENTRY BY DOCUMENT ID -----------------------------------

  static Future<List<Map<String, dynamic>>> getEntryByDocumentId(
    String documentId,
  ) async {
    final db = await CalculationParameterSqlDB.database;

    var listMap = await db.rawQuery(
      '''
        SELECT * 
        FROM ${CalculationParameterSqlDB.table}
        WHERE $documentId == documentId
      ''',
    );

    return listMap;
  }

// -------------------------------------------------------------------------
  static Future<List<CalcParaModel>> convertMapsIntoModel(
    List<Map<String, dynamic>> listMaps,
  ) async {
    return listMaps.map((map) => CalcParaModel.fromJSON(map)).toList();
  }

// ---------------------------------------------------------------------------
  static Future<Map<String, dynamic>?> getDiscountAndCommissionRe1() async {
    final db = await CalculationParameterSqlDB.database;

    var listMaps = await db.rawQuery(
      '''
        SELECT discount, commissionRe1
        FROM ${CalculationParameterSqlDB.table}
        ORDER BY timestamp DESC
        LIMIT 1
      ''',
    );

    if (listMaps.isEmpty) {
      return null;
    }

    return listMaps[0];
  }

  // ---------------------------------------------------------------------------
  static Future<Map<String, dynamic>> getKarkuniAndCommission() async {
    final db = await CalculationParameterSqlDB.database;

    var listMaps = await db.rawQuery(
      '''
        SELECT karkuni, commission
        FROM ${CalculationParameterSqlDB.table}
        ORDER BY timestamp DESC
        LIMIT 1
      ''',
    );

    if (listMaps.isEmpty) {
      return {
        "karkuni": "0",
        "commission": "0",
      };
    }

    return listMaps[0];
  }

// ---------------------- Check If DB is null ----------------------------------

  static Future<bool> isCalcParamsNull() async {
    final db = await CalculationParameterSqlDB.database;

    var listMaps = await db.rawQuery(
      '''
        SELECT karkuni, commission
        FROM ${CalculationParameterSqlDB.table}
        ORDER BY timestamp DESC
        LIMIT 1
      ''',
    );

    if (listMaps.isEmpty) {
      return true;
    }

    return false;
  }

// ---------------------------------------------------------------------------

}
