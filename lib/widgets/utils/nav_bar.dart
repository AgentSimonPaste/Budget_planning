import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {Key? key,
      required this.selectedIndex,
      required this.onDestinationSelected})
      : super(key: key);
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Transaction',
        ),
      ],
    );
  }
}
