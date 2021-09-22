import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/blocs/show_hide_password._bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/login_handler.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/login_validation.dart';
import 'package:mandimarket/src/ui/login/forgot_password.dart';
import 'package:mandimarket/src/ui/registration/registration_step_1.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/login_button.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ShowHidePasswordBloc? _showHidePasswordBloc;
  ShowCircularProgressBloc? _showCircularProgressBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController? _phoneCntrl;
  TextEditingController? _passCntrl;

  @override
  void initState() {
    _showHidePasswordBloc = ShowHidePasswordBloc();
    _showCircularProgressBloc = ShowCircularProgressBloc();
    _phoneCntrl = TextEditingController();
    _passCntrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _showHidePasswordBloc?.dispose();
    _showCircularProgressBloc?.dispose();
    _phoneCntrl!.dispose();
    _passCntrl!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  _titleText(),
                  SizedBox(height: 5.h),
                  _phoneNumberInput(),
                  _passwordInput(),
                  _forgetPasswordContainer(context),
                  _loginButton(),
                  SizedBox(height: 5.h),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _registerButton(context),
    );
  }

  StreamBuilder<bool> _loginButton() {
    return StreamBuilder<bool>(
      stream: _showCircularProgressBloc!.streamCircularProgress,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true)
            return LoginButton(
              onPressed: () {},
              title: "Login",
              wantWidget: true,
              widget: circularProgressForButton(),
            );
        }
        return LoginButton(
          onPressed: () => login(),
          title: "Login",
        );
      },
    );
  }

  Widget _registerButton(context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account ?",
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
          TextButton(
            onPressed: () {
              PushAndRemoveUntil(
                context,
                pushAndRemoveTo: Step1(),
              );
            },
            child: Text(
              'Register',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                color: YELLOW700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _forgetPasswordContainer(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: TextButton(
        child: Text(
          "Forgot password ?",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            color: YELLOW700,
          ),
        ),
        onPressed: () {
          Push(
            context,
            pushTo: ForgotPassword(),
          );
        },
      ),
    );
  }

  _titleText() {
    return Row(
      children: [
        Text(
          "Login",
          style: TextStyle(
            fontSize: 25.sp,
            color: BLACK,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  _phoneNumberInput() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        labelText: "Phone number",
      ),
      validator: (val) => LoginValidation.phoneNumber(val!),
      controller: _phoneCntrl,
    );
  }

  _passwordInput() {
    return StreamBuilder<bool>(
      stream: _showHidePasswordBloc!.showOrHide(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return TextFormField(
            controller: _passCntrl,
            obscureText: snapshot.data!,
            decoration: InputDecoration(
              labelText: "Password",
              suffix: GestureDetector(
                child: snapshot.data! ? Text("SHOW") : Text("HIDE"),
                onTap: () {
                  _showHidePasswordBloc!.setShowOrHide();
                },
              ),
            ),
            validator: (val) => LoginValidation.password(val!),
          );

        return Container();
      },
    );
  }

  final loginHandler = new LoginHandler();
  void login() {
    loginHandler.login(
      _phoneCntrl!.text.trim(),
      _passCntrl!.text.trim(),
      context,
      _formKey,
      _showCircularProgressBloc!,
    );
  }
}
