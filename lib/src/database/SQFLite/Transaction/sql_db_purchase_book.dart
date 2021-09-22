import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PurchaseBookSqlDB {
  static Database? _database;

  static final _phNo = userCredentials.ownersPhoneNumber;

  static final String _table = 'purchaseTable';

  static String get table => _table;

  static final String _colDocumentId = 'documentId';
  static final String _colBepariName = 'bepariName';
  static final String _colCustomerName = 'customerName';
  static final String _colPediName = 'pediName';
  static final String _colDawanName = 'dawanName';
  static final String _colUnit = 'unit';
  static final String _colRate = 'rate';
  static final String _colDalali = 'dalali';
  static final String _colDiscount = 'discount';
  static final String _colKacchiRakam = 'kacchiRakam';
  static final String _colPakkiRakam = 'pakkiRakam';
  static final String _colTimestamp = 'timestamp';
  static final String _colSelectedTimestamp = 'selectedTimestamp';

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
            $_colBepariName TEXT,
            $_colCustomerName TEXT,
            $_colDawanName TEXT,
            $_colPediName TEXT,
            $_colUnit TEXT,
            $_colRate TEXT,
            $_colDalali TEXT,
            $_colDiscount TEXT,
            $_colKacchiRakam TEXT,
            $_colPakkiRakam TEXT,
            $_colSelectedTimestamp TEXT,     
            $_colTimestamp TEXT
           )
          ''',
        );
      },
    );

    return database;
  }
}
