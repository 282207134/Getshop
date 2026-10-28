import 'package:flutter/foundation.dart';
import '../models/product.dart';

enum AppScreen {
  welcome('01-welcome', '1:465'),
  onboardingDark('02-onboarding-dark', '1:400'),
  onboardingProducts('03-onboarding-products', '1:51'),
  confirmation('04-confirmation', '1:270'),
  login('05-login', '1:505'),
  signup('06-signup', '1:565'),
  menu('07-menu', '1:338'),
  home('08-home', '1:994'),
  explore('09-explore', '1:625'),
  shop('10-shop', '1:922'),
  sort('11-sort', '1:2'),
  filterPrice('12-filter-price', '1:771'),
  filter('13-filter', '1:823'),
  favorites('14-favorites', '1:1077'),
  product('15-product', '1:84'),
  productRed('16-product-red', '1:144'),
  productGreen('17-product-green', '1:213'),
  cart('18-cart', '1:1154'),
  addCard('19-add-card', '1:1204'),
  shopDetail('20-shop-detail', '1:17'),
  timeline('21-timeline', '1:715');

  const AppScreen(this.fileName, this.pixsoId);
  final String fileName;
  final String pixsoId;
  static AppScreen fromName(String name) => values.firstWhere(
    (s) => s.name == name || s.fileName == name,
    orElse: () => welcome,
  );
}

enum ProductSort { popular, sales, alphabetical, designer }

class ShopFilter {
  const ShopFilter({
    this.min = 0,
    this.max = 200,
    this.categories = const {},
    this.colour,
    this.size = 'M',
  });
  final double min;
  final double max;
  final Set<String> categories;
  final String? colour;
  final String size;
}

class ShopController extends ChangeNotifier {
  ShopController({AppScreen initial = AppScreen.welcome}) : screen = initial {
    if (initial == AppScreen.productGreen) selected = products.first;
  }
  AppScreen screen;
  final List<AppScreen> _history = [];
  Product selected = products[1];
  int quantity = 1;
  String query = '';
  String category = 'Bag';
  String userName = 'Hayley Barles';
  String userEmail = 'hayleybarles@gmail.com';
  String? cardLastFour;
  String cardHolder = '';
  DateTime? orderedAt;
  bool signedIn = false;
  ProductSort sort = ProductSort.popular;
  ShopFilter filter = const ShopFilter();
  final Set<String> favorites = products.map((p) => p.id).toSet();
  final Map<String, int> cart = {'red': 1, 'black': 1, 'green': 2};

  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  int get total =>
      cart.entries.fold(0, (a, e) => a + byId(e.key).price * e.value);
  Product byId(String id) => products.firstWhere((p) => p.id == id);
  List<Product> get visibleProducts {
    final result = products.where((p) {
      final matchesQuery = '${p.name} ${p.colour} Jully Kingston'
          .toLowerCase()
          .contains(query.toLowerCase());
      final matchesCategory =
          filter.categories.isEmpty || filter.categories.contains('Women Bag');
      return matchesQuery &&
          matchesCategory &&
          p.price >= filter.min &&
          p.price <= filter.max &&
          (filter.colour == null || p.colour == filter.colour);
    }).toList();
    switch (sort) {
      case ProductSort.sales:
        result.sort((a, b) => b.sales.compareTo(a.sales));
      case ProductSort.alphabetical:
        result.sort((a, b) => a.name.compareTo(b.name));
      case ProductSort.designer:
        result.sort((a, b) => a.id.compareTo(b.id));
      case ProductSort.popular:
        break;
    }
    return result;
  }

  void go(AppScreen next) {
    if (next == screen) return;
    _history.add(screen);
    screen = next;
    notifyListeners();
  }

  void back() {
    screen = _history.isEmpty ? AppScreen.home : _history.removeLast();
    notifyListeners();
  }

  void openProduct(Product product, {bool classic = false}) {
    selected = product;
    quantity = 1;
    go(
      classic
          ? AppScreen.product
          : (product.colour == 'Green'
                ? AppScreen.productGreen
                : AppScreen.productRed),
    );
  }

  void setQuantity(int value) {
    quantity = value.clamp(1, 99);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (!favorites.remove(product.id)) favorites.add(product.id);
    notifyListeners();
  }

  void addToCart([Product? product]) {
    final p = product ?? selected;
    cart.update(p.id, (n) => n + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  void changeCart(String id, int delta) {
    final next = (cart[id] ?? 0) + delta;
    if (next <= 0) {
      cart.remove(id);
    } else {
      cart[id] = next.clamp(1, 99);
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    cart.remove(id);
    notifyListeners();
  }

  void search(String value) {
    query = value;
    notifyListeners();
  }

  void applyFilter(ShopFilter value) {
    filter = value;
    notifyListeners();
  }

  void applySort(ProductSort value) {
    sort = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void login({String? name, String? email}) {
    signedIn = true;
    if (name != null && name.trim().isNotEmpty) userName = name.trim();
    if (email != null) userEmail = email.trim();
    _history.clear();
    screen = AppScreen.confirmation;
    notifyListeners();
  }

  void logout() {
    signedIn = false;
    _history.clear();
    screen = AppScreen.login;
    notifyListeners();
  }

  void saveCard(String name, String number) {
    cardHolder = name.trim();
    final digits = number.replaceAll(' ', '');
    cardLastFour = digits.substring(digits.length - 4);
    back();
  }

  void checkout() {
    if (cart.isEmpty) return;
    orderedAt = DateTime.now();
    cart.clear();
    go(AppScreen.timeline);
  }
}
