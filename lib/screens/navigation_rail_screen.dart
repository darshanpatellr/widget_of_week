import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationRailScreen extends StatefulWidget {
  const NavigationRailScreen({super.key});

  @override
  State<NavigationRailScreen> createState() => _NavigationRailScreenState();
}

class _NavigationRailScreenState extends State<NavigationRailScreen> with
    SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation Rail & Flow icons")),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                        child: Icon(CupertinoIcons.home),
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
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  ],
                )),
              ],
            ),
            Flow(
              delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
              children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
            )
          ],
        ),
      ),
      // floatingActionButton: Positioned(
      //   bottom: 10,
      //   child: Flow(
      //     delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      //     children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
      //   ),
      // ),
    );
  }

  Widget flowMenuItem(IconData icon) {
    // final double buttonDiameter = MediaQuery.of(context).size.width / menuItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        // constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
          menuAnimation.status == AnimationStatus.completed
              ? menuAnimation.reverse()
              : menuAnimation.forward();
        },
        child: Icon(icon, color: Colors.white,size: 48,),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(i, transform: Matrix4.translationValues(dx * menuAnimation.value, 0, 0));
    }
  }
}
