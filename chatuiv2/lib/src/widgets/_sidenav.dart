import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/main.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';

import 'package:chatuiv2/src/views/_authpage.dart';

class SideNavWidget extends StatefulWidget {
  const SideNavWidget({Key? key}) : super(key: key);

  @override
  State<SideNavWidget> createState() => _SideNavWidgetState();
}

class _SideNavWidgetState extends State<SideNavWidget> {
  final TextStyle menuItem = const TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: 'Roboto',
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProv>(builder: (context, authProv, child) {
      final userData = authProv.userData;

      return Container(
        color: AppColors.black,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              color: AppColors.primaryColorDark,
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  children: [
                    // Fixed Logo Section at the top
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/payoorcart.png',
                        height: 30,
                      ),
                    ),

                    // Scrollable Middle Section
                    Expanded(
                      child: ListView(
                        children: [
                          // Your list items here
                        ],
                      ),
                    ),

                    // Fixed Bottom Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (userData == null) ...[
                            ListTile(
                              leading: Icon(Icons.person_outline,
                                  color: Colors.white),
                              title: Text('Sign In', style: menuItem),
                              onTap: () {
                                // Use root navigator
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed('/auth');
                                sideNavVisible.value = false;
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_outline,
                                  color: Colors.white),
                              title: Text('Sign up', style: menuItem),
                              onTap: () {
                                // Use root navigator
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed('/auth');
                                sideNavVisible.value = false;
                              },
                            ),
                          ],
                          if (userData != null) ...[
                            ListTile(
                              leading: Icon(Icons.person_outline,
                                  color: Colors.white),
                              title: Text(userData['email'], style: menuItem),
                              onTap: () {
                                // Handle settings
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.logout, color: Colors.white),
                              title: Text('Signout', style: menuItem),
                              onTap: () {
                                // Handle logout
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => sideNavVisible.value = false,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      );
    });
  }
}
