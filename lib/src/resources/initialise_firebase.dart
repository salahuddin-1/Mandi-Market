import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class InitialiseFireBase {
  static void initialiseFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
}
