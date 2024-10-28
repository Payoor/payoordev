import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/screens/_chatscreen.dart';
import 'package:chat/screens/_onboarding.dart';

import 'package:chat/providers/_message_provider.dart';
import 'package:chat/providers/_sidenav_provider.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => SideNavProvider()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Onboarding(),
          '/chatscreen': (context) => ChatScreen(),
        },
      ),
    );
  }
}
