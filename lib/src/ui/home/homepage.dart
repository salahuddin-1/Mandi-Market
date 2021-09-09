import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/login_model.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/authenticated_user/welcome_card.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/ui/login/login.dart';
import 'package:mandimarket/src/ui/registration/registration_step_2.dart';
import 'package:mandimarket/src/ui/registration/welcome_screen.dart';

import 'package:sizer/sizer.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModel>(
      future: SharedPref.getUserPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          injectUserCredentials(snapshot.data!);
          return InitialScreen();
        }

        return WelcomeScreen();
      },
    );
  }

  void injectUserCredentials(LoginModel loginModel) {
    userCredentials.saveUserCredentials(
      ownersPhoneNumber: loginModel.phoneNumber,
      ownersPassword: loginModel.password,
    );
  }
}

class TrialWidget extends StatefulWidget {
  const TrialWidget({Key? key}) : super(key: key);

  @override
  _TrialWidgetState createState() => _TrialWidgetState();
}

class _TrialWidgetState extends State<TrialWidget> {
  final masterPagination = MasterPaginationBloc(type: 'customer');

  @override
  void initState() {
    masterPagination.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            masterPagination.getUsers();
          },
        ),
        body: StreamBuilder<List<MasterModel>>(
          stream: null,
          // stream: masterPagination.streamMasterModel,
          builder: (context, masterModel) {
            if (masterModel.hasData) {
              return ListView.builder(
                itemCount: masterModel.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(masterModel.data![index].partyName),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Container container(double width, double height) {
    return Container(
      color: Colors.red,
      width: width.toDouble(),
      height: height.toDouble(),
    );
  }
}
