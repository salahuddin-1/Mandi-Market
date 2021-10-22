import 'package:flutter/material.dart';
import 'package:mandimarket/src/widgets/main_widgets.dart';
import 'package:sizer/sizer.dart';
import 'Billing_Entry/billing_entries_dialog.dart';
import 'Purchase_Book/on_tap_purchase_book.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late final BillingEntryDialog _billingEntryDialog;
  late final OnTapPurchaseBook _onTapPurchaseBook;

  @override
  void initState() {
    _billingEntryDialog = BillingEntryDialog();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _onTapPurchaseBook = OnTapPurchaseBook(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _onTapPurchaseBook.dispose();
    _billingEntryDialog.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(),
      body: Container(
        padding: EdgeInsets.only(top: 1.5.h, bottom: 2.h),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  MainTitleBox(
                      title: 'Purchase Book',
                      onPressed: () => _onTapPurchaseBook.onTap()),
                  MainTitleBox(
                      title: 'Billing Entry',
                      onPressed: () => _billingEntryDialog.selectDate(context)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  MainTitleBox(title: 'Payment Bepari', onPressed: () {}),
                  MainTitleBox(title: 'Payment Gawaal', onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  MainTitleBox(title: 'Receipt Customer', onPressed: () {}),
                  MainTitleBox(title: 'Pedi', onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  MainTitleBox(title: 'Adjustment', onPressed: () {}),
                  MainTitleBox(title: 'Other Parties Entry', onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  MainTitleBox(title: 'Expenses', onPressed: () {}),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  omTapTransactionType(BuildContext context, String type) {
    // Push(
    //   context,
    //   pushTo: MasterTable(
    //     type: type,
    //   ),
    // );
  }
}
