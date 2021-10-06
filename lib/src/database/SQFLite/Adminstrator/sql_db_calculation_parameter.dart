import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalculationParameterSqlDB {
  static Database? _database;

  static final _phNo = userCredentials.ownersPhoneNumber;

  static final String _table = 'calculationParameter';

  static String get table => _table;

  static final String _colDocumentId = 'documentId';
  static final String _colFromDateHash = 'fromDateHash';
  static final String _colFromDate = 'fromDate';
  static final String _colToDate = 'toDate';
  static final String _colToDateHash = 'toDateHash';
  static final String _colDiscount = 'discount';
  static final String _colCommissionRe1 = 'commissionRe1';
  static final String _colKarkuni = 'karkuni';
  static final String _colCommission = 'commission';
  static final String _colRemark = 'remark';
  static final String _colTimestamp = 'timestamp';

  static Future<Database> get database async {
    if (_database == null) {
      print("DB null");
      _database = await _initialiseDatabase();
    }
    print("DB return");
    return _database!;
  }

  static Future<Database> _initialiseDatabase() async {
    final dir = await getApplicationDocumentsDirectory();

    final path = join(dir.path, _phNo, "$_table.db");
    final database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        return await db.execute(
          '''
          CREATE TABLE $_table(
            $_colDocumentId TEXT PRIMARY KEY,
            $_colFromDateHash INTEGER,
            $_colToDateHash INTEGER,
            $_colDiscount TEXT,        
            $_colCommissionRe1 TEXT,
            $_colKarkuni TEXT,
            $_colCommission TEXT,
            $_colRemark TEXT,
            $_colFromDate TEXT,
            $_colToDate TEXT,
            $_colTimestamp TEXT
           )
          ''',
        );
      },
    );

    return database;
  }
}
