import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:rxdart/rxdart.dart';

class CalculateBillsBLOC {
  late String bepariName;
  late PaymentBepariModel _paymentBepariModel;

  final _streamCntrl = BehaviorSubject<PaymentBepariModel>();

  void sink(PaymentBepariModel paymentBepariModel) {
    _streamCntrl.add(paymentBepariModel);
  }

  Stream<PaymentBepariModel> get stream => _streamCntrl.stream;

  // GET PAYMENT BEPARI ENTRY
  Future<PaymentBepariModel> _getPaymentBepariEntry(String docID) async {
    final listMap = await PaymentBepariSQLResources.getPaymentBepariEntry(
      bepariName,
    );

    return PaymentBepariModel.fromJson(listMap!);
  }

  // GET ALL BILLS OF BEPARI
  Future<List<BillingEntryModel>> _getBills() async {
    final listMap = await BillingEntriesSQLResources.getBillsByBepariName(
      bepariName,
    );

    List<BillingEntryModel> listModel =
        listMap.map((map) => BillingEntryModel.fromJson(map)).toList();

    return listModel;
  }

  // GET OPENING BALANCE
  Future<MasterModel> _getOpeningBal() async {
    final listMap = await MasterSqlResources.getEntryByBepariName(
      bepariName,
    );

    MasterModel masterModel = MasterModel.fromJSON(
      listMap.first,
    );
    return masterModel;
  }

  // CALL THIS METHOD BEFORE SINK
  Future<void> _getAllAndAssignItToModel() async {
    _paymentBepariModel.masterModel = await _getOpeningBal();
    _paymentBepariModel.billEntryModels = await _getBills();
  }

  // SINK IN
  Future<void> _feedModelToStream() async {
    await _getAllAndAssignItToModel();
    _streamCntrl.add(_paymentBepariModel);
  }

  // DISPOSE
  void dispose() {
    _streamCntrl.close();
  }

  init() async {
    _paymentBepariModel = await _getPaymentBepariEntry(this.bepariName);

    // INIT CALLS
    await _feedModelToStream();
  }

  // CONSTRUCTOR
  CalculateBillsBLOC(String bepariName) {
    this.bepariName = bepariName;
    init();
  }
}
