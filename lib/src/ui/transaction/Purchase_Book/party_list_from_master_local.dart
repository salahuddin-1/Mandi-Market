import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Master_BLOC/feed_entries_to_master.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_get_user_bloc.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:mandimarket/src/ui/transaction/purchase_book/search.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class PartyListFromMasterLocal extends StatefulWidget {
  final String type;
  final PurchaseBookGetUserBLOC purchaseBookGetUserBLOC;

  PartyListFromMasterLocal({
    required this.type,
    required this.purchaseBookGetUserBLOC,
  });

  @override
  _PartyListFromMasterLocalState createState() =>
      _PartyListFromMasterLocalState();
}

class _PartyListFromMasterLocalState extends State<PartyListFromMasterLocal> {
  late final ShowCircularProgressBloc _showCircularProgressBloc;
  late FeedEntriesToMasterBLOC feedEntriesToMasterBLOC;

  @override
  void initState() {
    _showCircularProgressBloc = new ShowCircularProgressBloc();
    feedEntriesToMasterBLOC = FeedEntriesToMasterBLOC(widget.type);

    super.initState();
  }

  @override
  void dispose() {
    _showCircularProgressBloc.dispose();
    feedEntriesToMasterBLOC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text(
        widget.type,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () {
            Push(
              context,
              pushTo: SearchPurchaseBook(),
            );
          },
          icon: Icon(Icons.search),
        ),
      ],
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
    return StreamBuilder<List<MasterModel>>(
      stream: feedEntriesToMasterBLOC.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget();
        } else if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final mastermodel = snapshot.data![index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        widget.purchaseBookGetUserBLOC.updateTextFields(
                          val: mastermodel.partyName,
                          type: widget.type,
                        );
                        Pop(context);
                      },
                      title: Text(
                        mastermodel.partyName,
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

  // Expanded _noData() {
  //   return Expanded(
  //     child: Center(
  //       child: Text("No Data"),
  //     ),
  //   );
  // }

  Text _note() {
    return Text(
      '''Note : Only the parties that were added in Master/${widget.type} will appear here.''',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
