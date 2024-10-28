import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String route;

  NavItem({required this.title, required this.icon, required this.route});
}

class SideNavProvider extends ChangeNotifier {
  bool _isOpen = false;
  int _selectedIndex = 0;

  bool get isOpen => _isOpen;
  int get selectedIndex => _selectedIndex;

  final List<NavItem> _navItems = [
    NavItem(title: 'Orders', icon: Icons.home, route: '/'),
    //NavItem(title: 'Profile', icon: Icons.person, route: '/profile'),
    //NavItem(title: 'Settings', icon: Icons.settings, route: '/settings'),
    // NavItem(title: 'Help', icon: Icons.help, route: '/help'),
  ];

  List<NavItem> get navItems => _navItems;

  void openSideNav() {
    _isOpen = true;
    notifyListeners();
  }

  void closeSideNav() {
    _isOpen = false;
    notifyListeners();
  }

  void toggleSideNav() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
