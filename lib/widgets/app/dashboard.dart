import 'package:budget_planning/widgets/app/home_screen.dart';
import 'package:budget_planning/widgets/app/transaction_screen.dart';
import 'package:budget_planning/widgets/auth/log_in.dart';
import 'package:budget_planning/widgets/utils/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoading = false;
  int _selectedIndex = 0;

  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );

    setState(() {
      isLogoutLoading = false;
    });
  }

  List<String> tabNameNavigation = [
    //!!!!!
    'Home',
    'Transaction',
  ];

  List<Widget> pageViewList = [
    const HomeScreen(),
    const TransactionScreen(),
  ];

  void onSelectedTab(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageViewList[_selectedIndex],
      bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex, onDestinationSelected: onSelectedTab),
    );
  }
}
