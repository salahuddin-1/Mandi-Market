import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandimarket/src/blocs/handle_gallery_camera_bloc.dart';
import 'package:mandimarket/src/blocs/select_logo_bloc.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/registration_handler.dart';
import 'package:mandimarket/src/ui/registration/selectCompanyLogo.dart';
import 'package:mandimarket/src/validation/registration_company_details.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/login_button.dart';
import 'package:sizer/sizer.dart';

class Step2 extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String password;
  final String address;

  const Step2({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.address,
  }) : super(key: key);

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  SelectLogoBloc? _logoBloc;
  HandleGalleryCameraBloc? _galleryCameraBloc;
  ShowCircularProgressBloc? _showCircularProgressBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController? _companyNameCntrl;
  TextEditingController? _occupationCntrl;

  @override
  void initState() {
    _logoBloc = SelectLogoBloc();
    _showCircularProgressBloc = ShowCircularProgressBloc();
    _galleryCameraBloc = HandleGalleryCameraBloc();
    _companyNameCntrl = TextEditingController();
    _occupationCntrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _logoBloc?.dispose();
    _showCircularProgressBloc?.dispose();
    _galleryCameraBloc?.dispose();
    _companyNameCntrl!.dispose();
    _occupationCntrl!.dispose();
    super.dispose();
  }

  XFile? file;
  Uint8List? fileBytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: "Step 2 of 2",
        context: context,
      ).widget(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    _titleText(),
                    SizedBox(height: 3.h),
                    _compNameInput(),
                    _occupationInput(),
                    SizedBox(height: 2.h),
                    Divider(),
                    _selectProfilePhoto(),
                    Divider(),
                    _selectCompanyLogo(),
                    Divider(),
                    LoginButton(
                      onPressed: () => _register(),
                      title: "Register",
                    ),
                  ],
                ),
              ],
            ),
            _loading(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<bool> _loading() {
    return StreamBuilder(
      stream: _showCircularProgressBloc!.streamCircularProgress,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true)
            return circularProgressForWholeScreen(
              text: "Registering",
            );
        }
        return SizedBox.shrink();
      },
    );
  }

  _selectedLogo() {
    return StreamBuilder<SelectedLogoModel>(
      stream: _logoBloc?.getLogo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.index == -1)
            return _memoryImage(snapshot.data!.bytes!);
          else {
            return Container(
              color: Colors.white,
              child: Image.asset(snapshot.data!.path),
            );
          }
        }

        return _noImage();
      },
    );
  }

  Widget _memoryImage(Uint8List bytes) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(bytes),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  _noImage() {
    return Center(
      child: Text(
        "No image",
        textScaleFactor: 0.7.sp,
      ),
    );
  }

  _errorImage() {
    return Center(
      child: Text(
        "Error",
        textScaleFactor: 0.7.sp,
      ),
    );
  }

  _titleText() {
    return Text(
      "Company details",
      style: GoogleFonts.poiretOne(
        fontSize: 25.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  _compNameInput() {
    return TextFormField(
      controller: _companyNameCntrl,
      decoration: InputDecoration(
        labelText: "Company name",
      ),
      validator: (val) => RegistrationStep2Validation.companyName(val!),
    );
  }

  _occupationInput() {
    return TextFormField(
      controller: _occupationCntrl,
      decoration: InputDecoration(
        labelText: "Occupation",
      ),
      validator: (val) => RegistrationStep2Validation.occupaton(val!),
    );
  }

  Widget _selectProfilePhoto() {
    return Row(
      children: [
        Container(
          height: 20.w,
          width: 20.w,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: StreamBuilder<Uint8List>(
            stream: _galleryCameraBloc!.image(),
            builder: (context, snapshot) {
              if (snapshot.hasData) return _memoryImage(snapshot.data!);

              if (snapshot.hasError) return _errorImage();

              return _noImage();
            },
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => _selectProfilePhotoDialog(),
            child: FittedBox(
              child: Text(
                "Click to select profile photo",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 1,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectCompanyLogo() {
    return Row(
      children: [
        Container(
          height: 20.w,
          width: 20.w,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: _selectedLogo(),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => Push(
              context,
              pushTo: SelectCompanyLogo(
                logoBloc: _logoBloc!,
              ),
            ),
            child: FittedBox(
              child: Text(
                "Click to select company logo",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _dialogTextStyle() {
    return GoogleFonts.raleway(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 12.sp,
    );
  }

  _selectProfilePhotoDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[700],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                _galleryCameraBloc?.selectFromCamera();
                Pop(context);
              },
              child: Text(
                'Select from camera',
                style: _dialogTextStyle(),
              ),
            ),
            TextButton(
              onPressed: () {
                _galleryCameraBloc?.selectFromGallery();
                Pop(context);
              },
              child: Text(
                'Select from gallery',
                style: _dialogTextStyle(),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Pop(context);
              },
              child: Text(
                'Close',
                style: _dialogTextStyle(),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  _register() async {
    final logo = await _logoBloc!.getLogoImage();
    var registerProvider = new RegistrationHandler();

    registerProvider.register(
      widget.name,
      widget.phoneNumber,
      widget.address,
      widget.password,
      _companyNameCntrl!.text.trim(),
      _occupationCntrl!.text.trim(),
      logo,
      _galleryCameraBloc!.getValue,
      _formKey,
      context,
      _showCircularProgressBloc,
    );
  }
}
