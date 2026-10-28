import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getshop/src/app.dart';
import 'package:getshop/src/models/product.dart';
import 'package:getshop/src/state/shop_controller.dart';

const heights = <AppScreen, double>{
  AppScreen.home: 814,
  AppScreen.shop: 1029,
  AppScreen.sort: 841,
  AppScreen.filterPrice: 847,
  AppScreen.filter: 1227,
  AppScreen.favorites: 1001,
  AppScreen.addCard: 919,
  AppScreen.timeline: 847,
};

class ScreenshotTestBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get disableShadows => false;
}

void main() {
  ScreenshotTestBinding();
  setUpAll(() async {
    final loader = FontLoader('Avenir');
    for (final style in ['Book', 'Medium', 'Heavy', 'Black']) {
      loader.addFont(rootBundle.load('assets/fonts/Avenir-$style.ttf'));
    }
    await loader.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  for (final screen in AppScreen.values) {
    testWidgets('renders and captures ${screen.name}', (tester) async {
      tester.view.physicalSize = Size(375, heights[screen] ?? 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final shop = ShopController(initial: screen);
      if (screen == AppScreen.productGreen) shop.selected = products.first;
      await tester.pumpWidget(GetshopApp(controller: shop));
      await tester.runAsync(() async {
        final context = tester.element(find.byType(GetshopApp));
        for (final file in Directory(
          'assets/images',
        ).listSync().whereType<File>()) {
          await precacheImage(AssetImage(file.path), context);
        }
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(GetshopApp),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/docs/screenshots/${screen.fileName}.png',
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      shop.dispose();
    });
  }

  for (final viewport in [const Size(320, 640), const Size(430, 932)]) {
    testWidgets('all pages fit ${viewport.width.toInt()}px viewport', (
      tester,
    ) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final screen in AppScreen.values) {
        final shop = ShopController(initial: screen);
        await tester.pumpWidget(
          GetshopApp(key: ValueKey(screen), controller: shop),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: screen.name);
        await tester.pumpWidget(const SizedBox());
        shop.dispose();
      }
    });
  }

  testWidgets('login validates and product actions update the cart', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final shop = ShopController(initial: AppScreen.login);
    await tester.pumpWidget(GetshopApp(controller: shop));
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();
    expect(shop.signedIn, false);
    await tester.enterText(find.byKey(const Key('auth-name')), 'Demo Shopper');
    await tester.enterText(find.byKey(const Key('auth-password')), 'demo123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();
    expect(shop.screen, AppScreen.confirmation);
    expect(shop.userName, 'Demo Shopper');
    shop.openProduct(products[1]);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('Increase quantity')));
    await tester.tap(find.byKey(const Key('Increase quantity')));
    await tester.pumpAndSettle();
    expect(shop.quantity, 2);
    await tester.tap(find.text('Buy Now'));
    await tester.pumpAndSettle();
    expect(shop.screen, AppScreen.cart);
    expect(shop.cart['red'], 3);
    await tester.pumpWidget(const SizedBox());
    shop.dispose();
  });
}
