import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PaymentBepariSqlDB {
  static Database? _database;

  static final _phNo = userCredentials.ownersPhoneNumber;

  static final String _table = 'paymentBepariTable';

  static String get table => _table;

  static final String _colDocumentId = 'documentId';
  static final String _colTimestamp = 'timestamp';
  static final String _colSelectedTimestamp = 'selectedTimestamp';
  // Date Hash is of selected timestamp
  static final String _colDateHash = 'dateHash';

  static final String _colBepariName = 'bepariName';
  static final String _colOpeningBalance = 'openingBalance';
  static final String _colBills = 'bills';
  static final String _colPaidAmt = 'paidAmount';
  static final String _colReceivedAmt = 'receivedAmount';
  static final String _colReceivingAmt = 'receivingAmount';
  static final String _colBalanceAmtToPay = 'balanceAmountToPay';
  static final String _colBalanceAmountToReceive = 'balanceAmountToReceive';
  static final String _colPendingAmt = 'pendingAmount';
  static final String _colDebitOrCredit = 'debitOrCredit';

  static Future<Database> get database async {
    if (_database == null) {
      _database = await _initialiseDatabase();
    }

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
            $_colOpeningBalance TEXT,
            $_colBills TEXT,
            $_colPaidAmt TEXT,
            $_colPendingAmt TEXT,
            $_colDebitOrCredit TEXT,
            $_colReceivedAmt TEXT,
            $_colReceivingAmt TEXT,
            $_colBalanceAmtToPay TEXT,
            $_colBalanceAmountToReceive TEXT
           )
          ''',
        );
      },
    );

    return database;
  }
}
