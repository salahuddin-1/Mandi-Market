import 'package:get/get.dart';

final userCredentials = Get.put(UserCredentials());

class UserCredentials extends GetxController {
  String? _ownersPhoneNumber;
  String? _ownersPassword;

  String get ownersPhoneNumber => _ownersPhoneNumber!;
  String get ownersPassword => _ownersPassword!;

  void saveUserCredentials({
    required String ownersPhoneNumber,
    required String ownersPassword,
  }) {
    this._ownersPhoneNumber = ownersPhoneNumber;
    this._ownersPassword = ownersPassword;
  }
}
