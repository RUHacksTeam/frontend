import 'package:flutter/material.dart';
import '../find_donor.dart';
import '../list_view.dart';
import 'tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.BloodTypes});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  List BloodTypes;
  void _push(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(
    BuildContext context,
  ) {
    print(tabName[tabItem]);
    if (tabName[tabItem] == 'List_View') {
      return {
        TabNavigatorRoutes.root: (context) => listview(BloodTypes),
      };
    }
    return {
      TabNavigatorRoutes.root: (context) => FindDonor(BloodTypes),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
