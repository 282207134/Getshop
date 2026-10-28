import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/filter_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/product_screen.dart';
import 'state/shop_controller.dart';
import 'theme.dart';

class GetshopApp extends StatelessWidget {
  const GetshopApp({super.key, required this.controller});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'getshop',
    debugShowCheckedModeBanner: false,
    theme: shopTheme(),
    home: AnimatedBuilder(
      animation: controller,
      builder: (context, _) => PopScope(
        canPop:
            controller.screen == AppScreen.welcome ||
            controller.screen == AppScreen.home,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.back();
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SizedBox.expand(
                  child: KeyedSubtree(
                    key: ValueKey(controller.screen),
                    child: _screen(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Widget _screen() => switch (controller.screen) {
    AppScreen.welcome ||
    AppScreen.onboardingDark ||
    AppScreen.onboardingProducts ||
    AppScreen.confirmation => OnboardingScreen(controller),
    AppScreen.login => AuthScreen(controller),
    AppScreen.signup => AuthScreen(controller, signup: true),
    AppScreen.menu => MenuScreen(controller),
    AppScreen.home => HomeScreen(controller),
    AppScreen.explore => ExploreScreen(controller),
    AppScreen.shop => CatalogScreen(controller),
    AppScreen.sort => SortScreen(controller),
    AppScreen.filterPrice => FilterScreen(controller),
    AppScreen.filter => FilterScreen(controller, expanded: true),
    AppScreen.favorites => CatalogScreen(controller, favorites: true),
    AppScreen.product ||
    AppScreen.productRed ||
    AppScreen.productGreen => ProductScreen(controller),
    AppScreen.cart => CartScreen(controller),
    AppScreen.addCard => AddCardScreen(controller),
    AppScreen.shopDetail => ShopDetailScreen(controller),
    AppScreen.timeline => TimelineScreen(controller),
  };
}
