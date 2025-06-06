import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gym_sync/frontend/pages/customers_page.dart';
import 'package:gym_sync/frontend/pages/enroll_edit_customer_page.dart';
import 'package:gym_sync/frontend/pages/home_page.dart';

class BaseAppLayout extends StatefulWidget {
  const BaseAppLayout({super.key});

  @override
  State<BaseAppLayout> createState() => _BaseAppLayoutState();
}

class _BaseAppLayoutState extends State<BaseAppLayout> {
  int _activeIndex = 0;
  final List<IconData> _navigationIcons = [
    Icons.home_rounded,
    Icons.group_outlined,
  ];

  final List<Widget> _pages = [HomePage(), CustomersPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gym Sync',
          style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),

      body: _pages[_activeIndex],

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnrollEditCustomerPage()),
          );
        },
        backgroundColor: Theme.of(context).highlightColor,
        child: Icon(Icons.add, size: 30, color: Theme.of(context).primaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _navigationIcons,
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).highlightColor,
        inactiveColor: Theme.of(context).scaffoldBackgroundColor,
        iconSize: 30,
        activeIndex: _activeIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }
}
