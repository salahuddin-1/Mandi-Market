import 'package:flutter/material.dart';
import 'package:mandimarket/src/my_app.dart';
import 'package:mandimarket/src/resources/initialise_firebase.dart';

void main() {
  InitialiseFireBase.initialiseFirebase();
  runApp(MyApp());
}
