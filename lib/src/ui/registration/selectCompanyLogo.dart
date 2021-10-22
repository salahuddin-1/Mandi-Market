import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/select_logo_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/constants/images.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:sizer/sizer.dart';

class SelectCompanyLogo extends StatefulWidget {
  final SelectLogoBloc logoBloc;

  SelectCompanyLogo({
    required this.logoBloc,
  });
  @override
  _SelectCompanyLogoState createState() => _SelectCompanyLogoState();
}

class _SelectCompanyLogoState extends State<SelectCompanyLogo> {
  // @override
  // void dispose() {
  //   logoBloc.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: CustomScrollView(
        slivers: [
          _title(),
          _gridView(),
        ],
      ),
    );
  }

  _gridView() {
    return StreamBuilder<SelectedLogoModel>(
      stream: widget.logoBloc.getLogo,
      builder: (context, snapshot) {
        return SliverGrid.count(
          crossAxisCount: 3,
          children: [
            for (int i = 0; i < CustomImages.logos.length; i++)
              (i == snapshot.data?.index)
                  ? _selectedLogo(snapshot.data!.index)
                  : _logo(i),
          ],
        );
      },
    );
  }

  _selectedLogo(int index) {
    return Container(
      margin: EdgeInsets.all(0.5.w),
      child: Container(
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(CustomImages.logos[index]),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: CYAN900,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  _logo(int index) {
    return GestureDetector(
      onTap: () => widget.logoBloc.selectLogo(
        index,
        CustomImages.logos[index],
      ),
      child: Container(
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(CustomImages.logos[index]),
          ),
        ),
      ),
    );
  }

  _title() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 28.h,
      collapsedHeight: 28.h,
      flexibleSpace: Column(
        children: [
          SizedBox(height: 5.h),
          _chooseFromGalleryButton(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 3.h),
            child: Text("Or"),
          ),
          Text(
            "Select anyone from below :",
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  _chooseFromGalleryButton() {
    return MaterialButton(
      onPressed: () {
        Pop(context);
        widget.logoBloc.selectFromGallery();
      },
      minWidth: 50.w,
      color: CYAN900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Choose from gallery",
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.bold,
          color: BLACK,
          // letterSpacing: 1,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  _appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Select a company logo",
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.check,
            color: CYAN900,
          ),
        ),
      ],
    );
  }
}
