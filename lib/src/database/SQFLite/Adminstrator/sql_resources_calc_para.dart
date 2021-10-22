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

// -------------------------------------------------------------------------
  static Future<List<CalcParaModel>> convertMapsIntoModel(
    List<Map<String, dynamic>> listMaps,
  ) async {
    return listMaps.map((map) => CalcParaModel.fromJSON(map)).toList();
  }

// ---------------------------------------------------------------------------
  static Future<Map<String, dynamic>> getDiscountAndCommissionRe1() async {
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
      return {
        "discount": "0",
        "commissionRe1": "0",
      };
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

// ---------------------------------------------------------------------------

}
