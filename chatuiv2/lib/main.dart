import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'package:chatuiv2/src/widgets/_sidenav.dart';

/*import 'package:chatuiv2/src/views/_authpage.dart';
import 'package:chatuiv2/src/views/_welcome.dart';
import 'package:chatuiv2/src/views/_authenticatedchat.dart';
import 'package:chatuiv2/src/views/_authloading.dart';
import 'package:chatuiv2/src/views/_aboutus.dart';
import 'package:chatuiv2/src/views/_ordersdisplay.dart';
import 'package:chatuiv2/src/views/_orderconfirm.dart';*/

import 'package:chatuiv2/src/views/_authloading.dart' deferred as authLoading;
import 'package:chatuiv2/src/views/_authpage.dart' deferred as auth;
import 'package:chatuiv2/src/views/_welcome.dart' deferred as welcome;
import 'package:chatuiv2/src/views/_aboutus.dart' deferred as about;
import 'package:chatuiv2/src/views/_authenticatedchat.dart'
    deferred as authChat;
import 'package:chatuiv2/src/views/_ordersdisplay.dart' deferred as orders;
import 'package:chatuiv2/src/views/_orderconfirm.dart' deferred as orderConfirm;

import 'package:chatuiv2/src/providers/_onboardingprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_googleplaces.dart';
import 'package:chatuiv2/src/providers/_banipayprov.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => OnboardingProv()),
    ChangeNotifierProvider(create: (_) => AuthProv()),
    ChangeNotifierProvider(create: (_) => MessageProvider()),
    ChangeNotifierProvider(create: (_) => ResultListProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => GooglePlaces()),
    ChangeNotifierProvider(create: (_) => BaniPayProvider())
  ], child: MyApp()));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialPageRoute deferredRoute({
    required Future<void> Function() loadLibrary,
    required Widget Function() buildWidget,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return MaterialPageRoute(
      builder: (context) => FutureBuilder(
        future: loadLibrary(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return StackWithNav(
                  child: errorWidget ??
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              'Error loading page: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Go Back'),
                            ),
                          ],
                        ),
                      ),
                );
              }
              
              return StackWithNav(child: buildWidget());

            case ConnectionState.waiting:
              return loadingWidget ??
                  StackWithNav(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    ),
                  ));

            default:
              return StackWithNav(
                child: Center(
                  child: Text('Something went wrong'),
                ),
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: navigationKey,
      initialRoute: '/',
      title: 'Payoor',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return deferredRoute(
              loadLibrary: authLoading.loadLibrary,
              buildWidget: () => authLoading.AuthLoading(),
            );

          case '/auth':
            return deferredRoute(
              loadLibrary: auth.loadLibrary,
              buildWidget: () => auth.AuthPage(),
            );

          case '/welcome':
            return deferredRoute(
              loadLibrary: welcome.loadLibrary,
              buildWidget: () => welcome.Welcome(),
            );

          case '/about':
            return deferredRoute(
              loadLibrary: about.loadLibrary,
              buildWidget: () => about.AboutPayoor(),
            );

          case '/authchat':
            return deferredRoute(
              loadLibrary: authChat.loadLibrary,
              buildWidget: () => authChat.AuthenticatedChat(),
            );

          case '/orders':
            return deferredRoute(
              loadLibrary: orders.loadLibrary,
              buildWidget: () => orders.OrderDisplay(),
            );
        }

        final name = settings.name;
        if (name != null && name.startsWith('/confirmorder')) {
          final args = settings.arguments as Map<String, dynamic>?;
          return deferredRoute(
            loadLibrary: orderConfirm.loadLibrary,
            buildWidget: () =>
                orderConfirm.OrderConfirm(orderId: args?['orderId']),
          );
        }

        return null;
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
