import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: ShopColors.gradient),
    child: Column(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: ShopColors.background,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ShopHeader(controller),
                const PageTitle('Home'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: TextField(
                    key: const Key('search'),
                    onChanged: controller.search,
                    onSubmitted: (_) => controller.go(AppScreen.shop),
                    decoration: InputDecoration(
                      hintText: 'Search for anythink',
                      prefixIcon: const Icon(Icons.search, size: 22),
                      suffixIcon: IconButton(
                        tooltip: 'Filter products',
                        onPressed: () => controller.go(AppScreen.filterPrice),
                        icon: const Icon(
                          Icons.tune,
                          size: 18,
                          color: ShopColors.muted,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                if (controller.visibleProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(50),
                    child: Text(
                      'No products found. Try another search.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  SizedBox(
                    height: 305,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      itemCount: controller.visibleProducts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 19),
                      itemBuilder: (context, i) {
                        final product = controller.visibleProducts[i];
                        return SizedBox(
                          width: 179,
                          child: Material(
                            color: ShopColors.tile,
                            borderRadius: BorderRadius.circular(11),
                            child: InkWell(
                              onTap: () => controller.openProduct(
                                product,
                                classic: true,
                              ),
                              borderRadius: BorderRadius.circular(11),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  23,
                                  20,
                                  20,
                                  20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    const Text(
                                      'Confirmation\nmail for the',
                                      style: TextStyle(
                                        color: ShopColors.muted,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Price(product.price, size: 20),
                                        SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: IconButton.filled(
                                            tooltip:
                                                'Add ${product.name} to cart',
                                            style: IconButton.styleFrom(
                                              backgroundColor: ShopColors.muted,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () {
                                              controller.addToCart(product);
                                              showNotice(
                                                context,
                                                '${product.name} added to cart',
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(19, 32, 19, 18),
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 20),
                    itemBuilder: (context, i) => InkWell(
                      onTap: () => controller.openProduct(products[i]),
                      child: SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 66,
                              decoration: BoxDecoration(
                                color: ShopColors.tile,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[i].name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: ShopColors.muted,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Price(products[i].price, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => controller.go(AppScreen.cart),
          child: SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  for (final colour in ['green', 'red'])
                    Padding(
                      padding: const EdgeInsets.only(right: 11),
                      child: Container(
                        width: 43,
                        height: 44,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ShopColors.tile,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset('assets/images/bag-$colour.png'),
                      ),
                    ),
                  Container(
                    width: 43,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${controller.cartCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Price(controller.total, white: true),
                  const SizedBox(width: 17),
                  const Icon(Icons.east, color: Colors.white),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(gradient: ShopColors.gradient),
                child: Stack(
                  children: [
                    Positioned(
                      right: -80,
                      top: -120,
                      child: Image.asset(
                        'assets/images/contours.png',
                        width: 300,
                      ),
                    ),
                    Column(
                      children: [
                        ShopHeader(controller, light: true),
                        const SizedBox(height: 12),
                        const Text(
                          'Explore\nBag Models',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            height: 1.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -12),
                child: Container(
                  decoration: const BoxDecoration(
                    color: ShopColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(27),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -23),
                        child: Container(
                          height: 57,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              for (final cat in [
                                'Home',
                                'Gold',
                                'Bag',
                                'Ring',
                                'Shose',
                              ])
                                Expanded(
                                  child: InkWell(
                                    onTap: () => controller.setCategory(cat),
                                    child: Center(
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: controller.category == cat
                                              ? ShopColors.purple
                                              : Colors.grey,
                                          decoration: controller.category == cat
                                              ? TextDecoration.underline
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.go(AppScreen.shop),
                        child: Container(
                          height: 187,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [ShopColors.tile, Color(0xFFD4D4DE)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              controller.category == 'Bag'
                                  ? 'Women Bag'
                                  : '${controller.category} Collection',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      const Text(
                        'Favorite',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 195,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 13),
                          itemBuilder: (context, i) => SizedBox(
                            width: 110,
                            child: ProductTile(
                              products[i],
                              controller,
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        color: Colors.white70,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () => controller.go(AppScreen.home),
              icon: const Icon(
                Icons.home_outlined,
                size: 20,
                color: ShopColors.muted,
              ),
              label: const Text(
                'Home',
                style: TextStyle(color: ShopColors.muted, fontSize: 12),
              ),
            ),
            IconButton(
              tooltip: 'Shop',
              onPressed: () => controller.go(AppScreen.shop),
              icon: const Icon(Icons.search, color: ShopColors.muted, size: 20),
            ),
            IconButton(
              tooltip: 'Orders',
              onPressed: () => controller.go(AppScreen.timeline),
              icon: const Icon(
                Icons.notifications_outlined,
                color: ShopColors.muted,
                size: 20,
              ),
            ),
            IconButton(
              tooltip: 'Browse bags',
              onPressed: () => controller.go(AppScreen.shopDetail),
              icon: const Icon(
                Icons.star_border,
                color: ShopColors.muted,
                size: 20,
              ),
            ),
            IconButton(
              tooltip: 'Favorites',
              onPressed: () => controller.go(AppScreen.favorites),
              icon: const Icon(
                Icons.favorite,
                color: ShopColors.purple,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen(this.controller, {super.key, this.favorites = false});
  final ShopController controller;
  final bool favorites;
  @override
  Widget build(BuildContext context) {
    final list = favorites
        ? products.where((p) => controller.favorites.contains(p.id)).toList()
        : controller.visibleProducts.take(4).toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ShopHeader(controller, back: !favorites),
        if (favorites) ...[
          const PageTitle('Favorite'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
            child: GradientBanner(
              title: '${controller.favorites.length} Product',
              subtitle: 'Like favorites',
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
            child: Row(
              children: [
                Text(
                  controller.category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  tooltip: 'Explore categories',
                  onPressed: () => controller.go(AppScreen.explore),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 21),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 30),
            child: Text(
              'You can check the\nbag categories',
              style: TextStyle(
                fontSize: 18,
                color: ShopColors.muted,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ShopButton(
                    'Sort',
                    height: 61,
                    icon: Icons.tune,
                    onPressed: () => controller.go(AppScreen.sort),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: ShopButton(
                    'Filter',
                    height: 61,
                    icon: Icons.filter_alt_outlined,
                    color: ShopColors.muted,
                    onPressed: () => controller.go(AppScreen.filterPrice),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              children: [
                Icon(
                  favorites ? Icons.favorite_outline : Icons.search_off,
                  color: ShopColors.muted,
                  size: 42,
                ),
                const SizedBox(height: 16),
                Text(
                  favorites ? 'No saved items yet.' : 'No matching products.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () {
                    controller.applyFilter(const ShopFilter());
                    controller.search('');
                    controller.go(AppScreen.shop);
                  },
                  child: const Text('Browse all products'),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, bounds) => Wrap(
                spacing: 20,
                runSpacing: 25,
                children: list
                    .map(
                      (p) => SizedBox(
                        width: (bounds.maxWidth - 20) / 2,
                        child: ProductTile(p, controller, favorite: favorites),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        if (!favorites)
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 25, 24, 28),
            child: GradientBanner(
              title: 'Secure Shopping',
              subtitle: 'It is a long established fact',
              icon: Icons.verified_user,
              pink: true,
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
