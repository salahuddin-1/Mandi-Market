import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_get_user_bloc.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/purchase_book/search.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class PartyListFromMaster extends StatefulWidget {
  final String type;
  final PurchaseBookGetUserBLOC purchaseBookGetUserBLOC;

  PartyListFromMaster({
    required this.type,
    required this.purchaseBookGetUserBLOC,
  });

  @override
  _PartyListFromMasterState createState() => _PartyListFromMasterState();
}

class _PartyListFromMasterState extends State<PartyListFromMaster> {
  late final MasterPaginationBloc _masterPaginateBLOC;
  late final ScrollController _scrollController;
  late final ShowCircularProgressBloc _showCircularProgressBloc;

  @override
  void initState() {
    _masterPaginateBLOC = new MasterPaginationBloc(type: widget.type);
    _masterPaginateBLOC.getUsers(docLimit: 9);
    _scrollController = new ScrollController();
    _showCircularProgressBloc = new ShowCircularProgressBloc();
    _addListenerToScroll();
    super.initState();
  }

  @override
  void dispose() {
    _masterPaginateBLOC.dispose();
    _scrollController.dispose();
    _showCircularProgressBloc.dispose();
    super.dispose();
  }

  _addListenerToScroll() {
    _scrollController.addListener(
      () {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;

        if (maxScroll - currentScroll < 25.h) {
          _masterPaginateBLOC.getUsers(docLimit: 3);
        }
      },
    );
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
      stream: _masterPaginateBLOC.streamMasterModel,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget();
        } else if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
