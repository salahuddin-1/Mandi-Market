import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GetEntriesPaymentBepariBLOC {
  // INITIALIZERS
  final _streamCntrl = BehaviorSubject<ApiResponse<List<PaymentBepariModel>>>();

  // STREAM
  Stream<ApiResponse<List<PaymentBepariModel>>> get stream =>
      _streamCntrl.stream;

  // SINK
  getEntries() async {
    ApiResponse.loading('loading');

    try {
      final billsMap = await PaymentBepariSQLResources.getAllBills();

      final listModel = billsMap
          .map(
            (bill) => PaymentBepariModel.fromJson(bill),
          )
          .toList();

      _streamCntrl.add(
        ApiResponse.completed(listModel),
      );
    } catch (e) {
      ApiResponse.error(e.toString());
      print(e.toString());
    }
  }

  // DISPOSE

  void dispose() {
    _streamCntrl.close();
  }

  // CONSTRUCTOR
  GetEntriesPaymentBepariBLOC() {
    getEntries();
  }
}
