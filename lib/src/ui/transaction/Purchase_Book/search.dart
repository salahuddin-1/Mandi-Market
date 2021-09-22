import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';

class SearchPurchaseBook extends StatefulWidget {
  const SearchPurchaseBook({Key? key}) : super(key: key);

  @override
  _SearchPurchaseBookState createState() => _SearchPurchaseBookState();
}

class _SearchPurchaseBookState extends State<SearchPurchaseBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () => Pop(context),
      ),
      title: _search(),
    );
  }

  TextFormField _search() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.bold),
      cursorColor: BLACK,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Search',
        labelStyle: TextStyle(color: BLACK),
        suffixIcon: Icon(
          Icons.search,
          color: BLACK,
        ),
        focusColor: BLACK,
      ),
    );
  }
}
