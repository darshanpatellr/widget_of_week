import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationRailScreen extends StatefulWidget {
  const NavigationRailScreen({super.key});

  @override
  State<NavigationRailScreen> createState() => _NavigationRailScreenState();
}

class _NavigationRailScreenState extends State<NavigationRailScreen> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation Rail")),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              labelType: labelType,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Badge(
                      label: Text("47"),
                      child: Icon(CupertinoIcons.home)
                  ),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(CupertinoIcons.bell_fill),
                  label: Text("Notification"),
                ),
              ],
            ),
            VerticalDivider(),
            Expanded(child: Column()),
          ],
        ),
      ),
    );
  }
}
