import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_sidenav.dart';

import 'package:chatuiv2/src/views/_authpage.dart';
import 'package:chatuiv2/src/views/_welcome.dart';
import 'package:chatuiv2/src/views/_authenticatedchat.dart';
import 'package:chatuiv2/src/views/_authloading.dart';

import 'package:chatuiv2/src/providers/_onboardingprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_googleplaces.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => OnboardingProv()),
    ChangeNotifierProvider(create: (_) => AuthProv()),
    ChangeNotifierProvider(create: (_) => MessageProvider()),
    ChangeNotifierProvider(create: (_) => ResultListProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => GooglePlaces())
  ], child: MyApp()));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: navigationKey,
      initialRoute: '/',
      title: 'Payoor',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const StackWithNav(child: AuthLoading()),
        '/auth': (context) => const StackWithNav(child: AuthPage()),
        '/welcome': (context) => const StackWithNav(child: Welcome()),
        '/authchat': (context) =>
            const StackWithNav(child: AuthenticatedChat()),
      },
    );
  }
}

final ValueNotifier<bool> sideNavVisible = ValueNotifier(false);

class StackWithNav extends StatelessWidget {
  final Widget child;

  const StackWithNav({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<bool>(
          valueListenable: sideNavVisible,
          builder: (context, isVisible, _) {
            return Visibility(
              visible: isVisible,
              child: Positioned(
                top: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SideNavWidget(),
              ),
            );
          },
        ),
      ],
    );
  }
}
