import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GetParametersForBillingEntry {
  // VARIABLES
  late bool isEdit;
  late DateTime date;
  final _streamCntrl = BehaviorSubject<List<Map<String, dynamic>>>();
  final _calculationParamsStreamCntrl =
      BehaviorSubject<ApiResponse<Map<String, dynamic>>>();

  // STREAM
  Stream<List<Map<String, dynamic>>> get stream => _streamCntrl.stream;
  Stream<ApiResponse<Map<String, dynamic>>> get streamCalPara =>
      _calculationParamsStreamCntrl.stream;

  // SINK
  sink() async {
    _streamCntrl.add(await getBepariName());
  }

  // METHODS
// ----------------------- GET NON Duplicate Entries ---------------------------

  Future<List<Map<String, dynamic>>> _getNonDuplicateEntries() async {
    final listMap = await PurchaseBookSQLResources.getParamsForBillingEntry(
      dateHash: calculateDateHash(date),
    );

    if (isEdit) {
      return listMap;
    }

    final beparisInBillingEntry =
        await BillingEntriesSQLResources.getEntriesByDate(
      date,
    );

    List<Map<String, dynamic>> newListMap = [];

    for (int i = 0; i < listMap.length; i++) {
      bool exists = false;
      String purBookBepari = listMap[i]['bepariName'];

      for (int j = 0; j < beparisInBillingEntry.length; j++) {
        String billEnBepari = beparisInBillingEntry[j]['bepariName'];

        if (purBookBepari == billEnBepari) exists = true;
      }

      if (!exists) newListMap.add(listMap[i]);
    }

    return newListMap;
  }

// --------------------------- GET Bepari Name -------------------------------

  Future<List<Map<String, dynamic>>> getBepariName() async {
    Map<String, Map<String, dynamic>> parties = {};

    final newListMap = await _getNonDuplicateEntries();

    newListMap.forEach(
      (map) {
        String bepariName = map['bepariName'];
        int unit = int.tryParse(map['unit'])!;
        double discount = double.tryParse(map['discount'])!;
        double kacchiRakam = double.tryParse(map['kacchiRakam'])!;

        if (parties[bepariName] == null) {
          parties[bepariName] = {
            'bepariName': bepariName,
            "unit": unit,
            'discount': discount,
            'kacchiRakam': kacchiRakam,
          };
        } else {
          int tempUnit = parties[bepariName]!['unit'];
          double tempDiscount = parties[bepariName]!['discount'];
          double tempKacchiRakam = parties[bepariName]!['kacchiRakam'];

          parties[bepariName]!['unit'] = tempUnit + unit;
          parties[bepariName]!['discount'] = tempDiscount + discount;
          parties[bepariName]!['kacchiRakam'] = tempKacchiRakam + kacchiRakam;
        }
      },
    );

    List<Map<String, dynamic>> newList = [];

    parties.forEach((key, value) {
      newList.add(value);
    });

    // print(newList);

    return newList;
  }

// ------------------ GET Calculation Parameters -------------------------------

  Future<void> getCalPara() async {
    _calculationParamsStreamCntrl.add(ApiResponse.loading('Loading'));

    try {
      final calParam = await SQLresourcesCalcPara.getKarkuniAndCommission();

      _calculationParamsStreamCntrl.add(ApiResponse.completed(calParam));
    } catch (e) {
      _calculationParamsStreamCntrl.add(ApiResponse.error(e.toString()));
    }
  }

  // DISPOSE
  void dispose() {
    _streamCntrl.close();
    _calculationParamsStreamCntrl.close();
  }

  // GETTERS
  _CalculateCertainParams get calculateCertainParams =>
      _CalculateCertainParams();
  // CONSTRUCTOR
  GetParametersForBillingEntry(DateTime date, {bool isEdit = false}) {
    this.date = date;
    sink();
    getCalPara();

    this.isEdit = isEdit;
  }
}

// -------------------------- Class For Calculation Parameters -----------------

class _CalculateCertainParams {
  double commission({
    required String unit,
    required String commission,
  }) {
    return double.tryParse(commission)! * double.tryParse(unit)!;
  }

  double karkuni({
    required String unit,
    required String karkuni,
  }) {
    return double.tryParse(karkuni)! * double.tryParse(unit)!;
  }

  double netAmount({
    required double subAmount,
    required double discount,
    required double commission,
    required double karkuni,
    required double fees,
    required double aadmi,
    required double miscExpens,
    required double gavali,
    required double motor,
    required double rok,
    required double balAmount,
  }) {
    final netAmount = subAmount -
        (discount +
            commission +
            karkuni +
            fees +
            aadmi +
            miscExpens +
            gavali +
            motor +
            rok +
            balAmount);

    return netAmount;
  }
}
