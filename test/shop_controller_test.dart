import 'package:flutter_test/flutter_test.dart';
import 'package:getshop/src/models/product.dart';
import 'package:getshop/src/state/shop_controller.dart';

void main() {
  test('cart quantities, totals and checkout stay consistent', () {
    final shop = ShopController();
    expect(shop.cartCount, 4);
    expect(shop.total, 78);
    shop.selected = products[2];
    shop.setQuantity(3);
    shop.addToCart();
    expect(shop.cart['yellow'], 3);
    expect(shop.total, 123);
    shop.changeCart('yellow', -1);
    expect(shop.total, 108);
    shop.removeFromCart('yellow');
    expect(shop.total, 78);
    shop.checkout();
    expect(shop.screen, AppScreen.timeline);
    expect(shop.cartCount, 0);
    expect(shop.total, 0);
    expect(shop.orderedAt, isNotNull);
    shop.dispose();
  });

  test('search, price, category, colour and sorting affect results', () {
    final shop = ShopController();
    shop.search('red');
    expect(shop.visibleProducts.map((p) => p.id), ['red', 'rose']);
    shop.search('');
    shop.applyFilter(const ShopFilter(min: 10, max: 18, colour: 'Green'));
    expect(shop.visibleProducts.map((p) => p.id), ['olive']);
    shop.applyFilter(const ShopFilter(categories: {'Gold'}));
    expect(shop.visibleProducts, isEmpty);
    shop.applyFilter(const ShopFilter());
    shop.applySort(ProductSort.sales);
    expect(shop.visibleProducts.first.id, 'red');
    shop.applySort(ProductSort.alphabetical);
    expect(shop.visibleProducts.first.id, 'black');
    shop.dispose();
  });

  test('favorites and navigation retain session state', () {
    final shop = ShopController(initial: AppScreen.home);
    shop.toggleFavorite(products.first);
    expect(shop.favorites, isNot(contains('green')));
    shop.go(AppScreen.shop);
    shop.go(AppScreen.filterPrice);
    shop.back();
    expect(shop.screen, AppScreen.shop);
    shop.back();
    expect(shop.screen, AppScreen.home);
    shop.setQuantity(0);
    expect(shop.quantity, 1);
    shop.setQuantity(1000);
    expect(shop.quantity, 99);
    shop.saveCard('Demo Shopper', '4242424242424242');
    expect(shop.cardLastFour, '4242');
    shop.dispose();
  });
}
