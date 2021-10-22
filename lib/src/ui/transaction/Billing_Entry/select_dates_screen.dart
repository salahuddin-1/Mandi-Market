import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/get_mandi_dates_BLOC.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';

class SelectDates extends StatefulWidget {
  const SelectDates({Key? key}) : super(key: key);

  @override
  _SelectDatesState createState() => _SelectDatesState();
}

class _SelectDatesState extends State<SelectDates> {
  late final GetMandiDatesBLOC _getMandiDates;
  @override
  void initState() {
    _getMandiDates = GetMandiDatesBLOC.intance;
    super.initState();
  }

  @override
  void dispose() {
    _getMandiDates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: StreamBuilder<List<String>>(
        stream: _getMandiDates.stream,
        builder: (context, snapshot) {
          var list = snapshot.data;

          if (snapshot.hasError) {
            return const ErrorText();
          }

          if (snapshot.hasData) {
            if (list!.length == 0) {
              return const NoData();
            }

            Set<String> dates = Set();
            Set<String> isoDates = Set();

            list.forEach(
              (isoDate) {
                final formattedDate = formatDate(DateTime.tryParse(isoDate));

                if (!dates.contains(formattedDate)) {
                  dates.add(formattedDate);
                  isoDates.add(isoDate);
                }
              },
            );

            return _dates(dates.toList(), isoDates.toList());
          }

          return circularProgress();
        },
      ),
    );
  }

  ListView _dates(List<String> list, List<String> isoList) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var item = list[index];
        var isoDate = isoList[index];

        return Column(
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pop(context, isoDate);
                },
                leading: Text('${index + 1}'),
                title: Text("$item"),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: 'Select a Mandi date',
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          color: Colors.white,
        ),
      ],
    );
  }
}
