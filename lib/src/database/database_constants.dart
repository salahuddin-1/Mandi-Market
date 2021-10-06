import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final usersRef = FirebaseFirestore.instance.collection("users");
  static final mastersRef = FirebaseFirestore.instance.collection("master");
  static final transactionRef =
      FirebaseFirestore.instance.collection("transaction");
  static final administratorRef =
      FirebaseFirestore.instance.collection("administrator");
}
