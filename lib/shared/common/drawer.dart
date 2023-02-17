import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../inbox/inbox_screen.dart';
import '../../preferences/preferences_screen.dart';

class DrawerItem {
  const DrawerItem({
    required this.title,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final IconData icon;
  final String routeName;
}

const _mainItems = [
  DrawerItem(
    title: 'Inbox',
    icon: Icons.inbox,
    routeName: InboxScreen.routeName,
  ),
];

const _bottomItems = [
  DrawerItem(
    title: 'Preferences',
    icon: Icons.settings,
    routeName: PreferencesScreen.routeName,
  ),
];

Widget drawer(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          ..._mainItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () => context.goNamed(item.routeName),
            );
          }).toList(),
          const Spacer(),
          const Divider(),
          ..._bottomItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () => context.goNamed(item.routeName),
            );
          }).toList(),
        ],
      ),
    ),
  );
}
