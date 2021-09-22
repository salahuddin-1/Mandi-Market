import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MasterSqlDB {
  static Map<String, Database>? _databases;

  static final _phNo = userCredentials.ownersPhoneNumber;

  //
  static final String _bepariTable = 'bepari';
  static final String _customerTable = 'customer';
  static final String _gawaalTable = 'gawaal';
  static final String _dawanTable = 'dawan';
  static final String _otherPartiesTable = 'otherparties';

  static List<String> _tables = [
    _bepariTable,
    _customerTable,
    _gawaalTable,
    _dawanTable,
    _otherPartiesTable,
  ];

  //
  static String get bepariTable => _bepariTable;
  static String get customerTable => _customerTable;
  static String get gawaalTable => _gawaalTable;
  static String get dawanTable => _dawanTable;
  static String get otherPartiesTable => _otherPartiesTable;

  static final String _colDocumentId = 'documentId';
  static final String _colPartyName = 'partyName';
  static final String _colAddress = 'address';
  static final String _colPhoneNumber = 'phoneNumber';
  static final String _colOpeningBalance = 'openingBalance';
  static final String _colRemark = 'remark';
  static final String _colDebitOrCredit = 'debitOrCredit';
  static final String _colTimestamp = 'timestamp';

  static Future<Map<String, Database>> get databases async {
    if (_databases == null) {
      print("Master DB null");
      _databases = await _initialiseDatabase();
    }
    print("Master DB return");
    return _databases!;
  }

  // table : path
  static Map<String, String> _paths = {};

  static Future<Map<String, Database>> _initialiseDatabase() async {
    final dir = await getApplicationDocumentsDirectory();

    _tables.forEach(
      (table) {
        _paths[table] = join(dir.path, _phNo, 'master', "$table.db");
      },
    );

    Map<String, Database> databases = {};

    await Future.forEach(_paths.keys, (String table) async {
      var path = _paths[table];

      var database = await openDataBase(
        path: path!,
        table: table,
      );

      databases[table] = database;
    });

    return databases;
  }

  static Future<Database> openDataBase({
    required String table,
    required String path,
  }) async {
    final database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        return await db.execute(
          '''
          CREATE TABLE $table(
            $_colDocumentId INTEGER PRIMARY KEY,
            $_colPartyName TEXT,
            $_colAddress TEXT,
            $_colPhoneNumber TEXT,
            $_colOpeningBalance INTEGER,
            $_colRemark TEXT,
            $_colDebitOrCredit TEXT,                     
            $_colTimestamp TEXT
           )
          ''',
        );
      },
    );

    return database;
  }
}
