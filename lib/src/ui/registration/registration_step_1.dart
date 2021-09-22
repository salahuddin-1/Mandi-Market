import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/blocs/show_hide_password._bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/registration_handler.dart';
import 'package:mandimarket/src/ui/login/login.dart';
import 'package:mandimarket/src/validation/register_validation.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/login_button.dart';
import 'package:sizer/sizer.dart';

class Step1 extends StatefulWidget {
  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _nameCntrl;

  TextEditingController? _phoneCntrl;

  TextEditingController? _addressCntrl;

  TextEditingController? _passCntrl;

  TextEditingController? _confirmPassCntrl;

  ShowHidePasswordBloc? _showHidePasswordBloc;
  ShowCircularProgressBloc? _showCircularProgressBloc;

  @override
  void initState() {
    _showHidePasswordBloc = new ShowHidePasswordBloc();
    _showCircularProgressBloc = ShowCircularProgressBloc();
    _nameCntrl = new TextEditingController();
    _phoneCntrl = TextEditingController();
    _addressCntrl = TextEditingController();
    _passCntrl = TextEditingController();
    _confirmPassCntrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _showHidePasswordBloc!.dispose();
    _showCircularProgressBloc?.dispose();
    _nameCntrl!.dispose();
    _phoneCntrl!.dispose();
    _addressCntrl!.dispose();
    _passCntrl!.dispose();
    _confirmPassCntrl!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: "Step 1 of 2",
        context: context,
      ).widget(),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  _titleText(),
                  SizedBox(height: 3.h),
                  _nameInput(),
                  _phoneNumberInput(),
                  _addressInput(),
                  _passwordInput(),
                  _confirmPasswordInput(),
                  _submitButton(),
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

  StreamBuilder<bool> _submitButton() {
    return StreamBuilder<bool>(
      stream: _showCircularProgressBloc!.streamCircularProgress,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true)
            return LoginButton(
              onPressed: () {},
              title: "",
              wantWidget: true,
              widget: circularProgressForButton(),
            );
        }
        return LoginButton(
          onPressed: () => _submit(context),
          title: "Submit",
        );
      },
    );
  }

  _titleText() {
    return Text(
      "Register",
      style: TextStyle(
        fontSize: 25.sp,
        color: BLACK,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  _phoneNumberInput() {
    return TextFormField(
      controller: _phoneCntrl,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        labelText: "Phone number",
      ),
      validator: (val) => RegisterValidation.phoneNumber(val!),
    );
  }

  _nameInput() {
    return TextFormField(
      controller: _nameCntrl,
      decoration: InputDecoration(
        labelText: "Name",
      ),
      validator: (val) => RegisterValidation.name(val!),
    );
  }

  _addressInput() {
    return TextFormField(
      controller: _addressCntrl,
      decoration: InputDecoration(
        labelText: "Address",
      ),
      validator: (val) => RegisterValidation.address(val!),
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
            validator: (val) => RegisterValidation.password(val!),
          );

        return Container();
      },
    );
  }

  _confirmPasswordInput() {
    return TextFormField(
      controller: _confirmPassCntrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Confirm password",
      ),
      validator: (val) => RegisterValidation.confirmPassword(
        val!,
        _passCntrl!.text.trim(),
      ),
    );
  }

  Widget _registerButton(context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already registered ?",
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
          TextButton(
            onPressed: () {
              PushAndRemoveUntil(
                context,
                pushAndRemoveTo: Login(),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: YELLOW700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _registerHandler = new RegistrationHandler();
  _submit(context) {
    _registerHandler.submitStepOne(
      _nameCntrl!.text.trim(),
      _phoneCntrl!.text.trim(),
      _addressCntrl!.text.trim(),
      _confirmPassCntrl!.text.trim(),
      _formKey,
      context,
      _showCircularProgressBloc!,
    );
  }
}
