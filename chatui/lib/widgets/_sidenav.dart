import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/providers/_sidenav_provider.dart';

class CustomSideNav extends StatelessWidget {
  final double width;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle? textStyle;

  const CustomSideNav({
    Key? key,
    this.width = 350,
    this.backgroundColor = Colors.white,
    this.selectedColor = ThemeColors.white,
    this.unselectedColor = ThemeColors.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SideNavProvider>(
      builder: (context, sideNavProvider, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          right: sideNavProvider.isOpen ? 0 : -width,
          top: 0,
          bottom: 0,
          width: width,
          child: Container(
            color: backgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: width,
                    decoration: const BoxDecoration(
                      color: ThemeColors.primaryColor,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 30, bottom: 30),
                        child: Column(
                          children: [
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Close the side navigation
                                    context
                                        .read<SideNavProvider>()
                                        .toggleSideNav();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                // Add an empty SizedBox to balance the row
                                const SizedBox(width: 24),
                              ],
                            )),
                            const SizedBox(height: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 300,
                                  width: width,
                                  child: ListView.builder(
                                    itemCount: sideNavProvider.navItems.length,
                                    itemBuilder: (context, index) {
                                      NavItem item =
                                          sideNavProvider.navItems[index];
                                      bool isSelected =
                                          sideNavProvider.selectedIndex ==
                                              index;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          ListTile(
                                            leading: Icon(
                                              item.icon,
                                              color: isSelected
                                                  ? selectedColor
                                                  : unselectedColor,
                                            ),
                                            title: Text(
                                              item.title,
                                              style: (textStyle ?? TextStyle())
                                                  .copyWith(
                                                color: isSelected
                                                    ? selectedColor
                                                    : unselectedColor,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            onTap: () {
                                              sideNavProvider
                                                  .setSelectedIndex(index);
                                              Navigator.of(context)
                                                  .pushNamed(item.route);
                                              sideNavProvider.toggleSideNav();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  child: GestureDetector(
                                    child: const Text('Log out',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.2,
                                        )),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
