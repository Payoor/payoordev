import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/views/_landingscreen.dart';
import 'package:chatuiv2/src/views/_authpage.dart';
import 'package:chatuiv2/src/views/_welcome.dart';
import 'package:chatuiv2/src/views/_authenticatedchat.dart';

import 'package:chatuiv2/src/providers/_onboardingprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => OnboardingProv()),
    ChangeNotifierProvider(create: (_) => AuthProv())
  ], child: MyApp()));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      title: 'Payoor',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LandingScreen(),
        '/auth': (context) => const AuthPage(),
        '/welcome': (context) => const Welcome(),
        '/authchat': (context) => const AuthenticatedChat(),
      },
    );
  }
}
