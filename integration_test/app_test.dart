import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:getshop/src/app.dart';
import 'package:getshop/src/models/product.dart';
import 'package:getshop/src/state/shop_controller.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android screenshots and complete demo checkout', (tester) async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await binding.convertFlutterSurfaceToImage();
    for (final screen in AppScreen.values) {
      final shop = ShopController(initial: screen);
      if (screen == AppScreen.productGreen) shop.selected = products.first;
      await tester.pumpWidget(
        GetshopApp(key: ValueKey(screen), controller: shop),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.name);
      await binding.takeScreenshot(screen.fileName);
      await tester.pumpWidget(const SizedBox());
      shop.dispose();
    }

    final shop = ShopController(initial: AppScreen.login);
    await tester.pumpWidget(GetshopApp(controller: shop));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('auth-name')), 'Demo Shopper');
    await tester.enterText(find.byKey(const Key('auth-password')), 'demo123');
    await tester.ensureVisible(find.byKey(const Key('auth-submit')));
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();
    expect(shop.signedIn, true);
    await tester.tap(find.text('Start Shoping'));
    await tester.pumpAndSettle();
    expect(shop.screen, AppScreen.home);
    shop.openProduct(products[1]);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('Increase quantity')));
    await tester.tap(find.byKey(const Key('Increase quantity')));
    await tester.pumpAndSettle();
    expect(shop.quantity, 2);
    await tester.tap(find.text('Buy Now'));
    await tester.pumpAndSettle();
    expect(shop.cart['red'], 3);
    await tester.tap(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    expect(shop.screen, AppScreen.addCard);
    for (final field in [
      ('card-name', 'Demo Shopper'),
      ('card-number', '4242424242424242'),
      ('card-month', '12'),
      ('card-year', '35'),
      ('card-cvc', '123'),
    ]) {
      await tester.ensureVisible(find.byKey(Key(field.$1)));
      await tester.enterText(find.byKey(Key(field.$1)), field.$2);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-card')));
    await tester.tap(find.byKey(const Key('save-card')));
    await tester.pumpAndSettle();
    expect(shop.cardLastFour, '4242');
    expect(shop.screen, AppScreen.cart);
    await tester.tap(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    expect(shop.screen, AppScreen.timeline);
    expect(shop.cartCount, 0);
    await binding.takeScreenshot('22-checkout-complete');
  });
}
