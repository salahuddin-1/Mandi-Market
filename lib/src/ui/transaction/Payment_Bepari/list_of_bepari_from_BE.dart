import 'package:flutter/material.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class ListOfBepariFromBE extends StatefulWidget {
  const ListOfBepariFromBE({Key? key}) : super(key: key);

  @override
  _ListOfBepariFromBEState createState() => _ListOfBepariFromBEState();
}

class _ListOfBepariFromBEState extends State<ListOfBepariFromBE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h),
          _note(),
          SizedBox(height: 5.h),
          _parties(),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _parties() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget();
        } else if (snapshot.hasData) {
          final list = snapshot.data;

          if (list == null) {
            return _noData();
          }

          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final params = list[index];

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context, params);
                      },
                      title: Text(
                        params['bepariName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(color: Colors.black),
                  ],
                );
              },
            ),
          );
        }

        return circularProgress();
      },
    );
  }

  Expanded _errorWidget() {
    return Expanded(
      child: Center(
        child: Text("Something went wrong"),
      ),
    );
  }

  Expanded _noData() {
    return Expanded(
      child: Center(
        child: Text("No Data"),
      ),
    );
  }

  Text _note() {
    return Text(
      '''Note : Only the calculations that were done in Billing Entry with respective Bepari Name will appear here.''',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.6,
      ),
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: 'Bepari',
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
