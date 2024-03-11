import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_safety_app/child/bottom_screens/add_contacts.dart';
import 'package:women_safety_app/child/bottom_screens/chat_page.dart';
import 'package:women_safety_app/child/bottom_screens/child_home_page.dart';
import 'package:women_safety_app/child/bottom_screens/profile_page.dart';
import 'package:women_safety_app/child/bottom_screens/review_page.dart';
import 'package:women_safety_app/profile_mode/settings.dart';

import '../components/fab_bar_bottom.dart';

class BottomPage extends StatefulWidget {
  BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<Widget> internetPages = [
    HomeScreen(),
    AddContactsPage(),
    CheckUserStatusBeforeChat(),
    ReviewPage(),
    SettingsPage()
  ];
  List<Widget> noInternetPages = [
    HomeScreen(),
    AddContactsPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("internet issue {'Couldn\'t check connectivity status' $e}");
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    print("=====>>>> ${_connectionStatus}");
  }

  getConnectivity() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: DefaultTabController(
          initialIndex: currentIndex,
          length: _connectionStatus == ConnectivityResult.none
              ? noInternetPages.length
              : internetPages.length,
          child: Scaffold(
              body: _connectionStatus == ConnectivityResult.none
                  ? noInternetPages[currentIndex]
                  : internetPages[currentIndex],
              bottomNavigationBar: FABBottomAppBar(
                onTabSelected: onTapped,
                items: _connectionStatus == ConnectivityResult.none
                    ? [
                        FABBottomAppBarItem(iconData: Icons.home, text: "home"),
                        FABBottomAppBarItem(
                            iconData: Icons.contacts, text: "contacts"),
                      ]
                    : [
                        FABBottomAppBarItem(iconData: Icons.home, text: "home"),
                        FABBottomAppBarItem(
                            iconData: Icons.contacts, text: "contacts"),
                        FABBottomAppBarItem(iconData: Icons.chat, text: "chat"),
                        FABBottomAppBarItem(
                            iconData: Icons.rate_review, text: "Ratings"),
                        FABBottomAppBarItem(
                            iconData: Icons.settings, text: "Settings"),
                      ],
              )),
        ));
  }
}
