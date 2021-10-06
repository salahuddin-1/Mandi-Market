import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BillingEntrySqlDB {
  static Database? _database;

  static final _phNo = userCredentials.ownersPhoneNumber;

  static final String _table = 'billingEntryTable';

  static String get table => _table;

  static final String _colSelectedTimestamp = 'selectedTimestamp';
  static final String _colTimestamp = 'timestamp';
  static final String _colDateHash = 'dateHash';
  static final String _colBepariName = 'bepariName';
  static final String _colUnit = 'unit';
  static final String _colAadmi = 'aadmi';
  static final String _colDalali = 'dalali';
  static final String _colDiscount = 'discount';
  static final String _colKarkuni = 'karkuni';
  static final String _colFees = 'fees';
  static final String _colSubAmount = 'subAmount';
  static final String _colNetAmount = 'netAmount';
  static final String _colGavalsName = 'gavalsName';
  static final String _colGavali = 'gavali';
  static final String _colMotor = 'motor';
  static final String _colRok = 'rok';
  static final String _colBaki = 'baki';
  static final String _colDescription = 'description';
  static final String _colMiscExp = 'miscExpenses';
  static final String _colDocumentId = 'documentId';

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
            $_colDocumentId INTEGER PRIMARY KEY,
            $_colSelectedTimestamp TEXT,     
            $_colTimestamp TEXT,
            $_colDateHash INTEGER,
            $_colBepariName TEXT,
            $_colUnit TEXT,
            $_colAadmi TEXT,
            $_colDalali TEXT,
            $_colDiscount TEXT,
            $_colKarkuni TEXT,
            $_colFees TEXT,
            $_colSubAmount TEXT,
            $_colNetAmount TEXT,
            $_colGavalsName TEXT,
            $_colGavali TEXT,
            $_colMotor TEXT,
            $_colRok TEXT,
            $_colBaki TEXT,
            $_colDescription TEXT,
            $_colMiscExp TEXT
           )
          ''',
        );
      },
    );

    return database;
  }
}
