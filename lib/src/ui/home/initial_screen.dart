import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/ui/admin/admin.dart';
import 'package:mandimarket/src/ui/master/master.dart';
import 'package:mandimarket/src/ui/report/report.dart';
import 'package:mandimarket/src/ui/transaction/transaction.dart';
import 'package:mandimarket/src/ui/utilities/utllities.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  PersistentTabController? _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white10, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      MasterScreen(),
      TransactionScreen(),
      ReportScreen(),
      AdminScreen(),
      UtilitiesScreen(),
    ];
  }

  _navBarItem(String title, {IconData icon = Icons.home}) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: (title),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _navBarItem(
        "Master",
        icon: Icons.home,
      ),
      _navBarItem(
        "Transaction",
        icon: Icons.transfer_within_a_station,
      ),
      _navBarItem(
        "Report",
        icon: Icons.file_copy,
      ),
      _navBarItem(
        "Admin",
        icon: Icons.person,
      ),
      _navBarItem(
        "Utilities",
        icon: Icons.work_rounded,
      ),
    ];
  }
}
