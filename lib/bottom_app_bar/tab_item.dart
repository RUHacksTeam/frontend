import 'package:flutter/material.dart';

enum TabItem { red, green, blue }

const Map<TabItem, String> tabName = {
  TabItem.red: 'List_View',
  TabItem.green: 'Map_View',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.red: Colors.red,
  TabItem.green: Colors.green,
};