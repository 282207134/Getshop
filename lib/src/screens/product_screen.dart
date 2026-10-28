import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) {
    final classic = controller.screen == AppScreen.product;
    final p = controller.selected;
    return LayoutBuilder(
      builder: (context, bounds) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: bounds.maxHeight - 110),
                child: Column(
                  children: [
                    Container(
                      height: classic
                          ? bounds.maxHeight * .47
                          : bounds.maxHeight * .49,
                      constraints: const BoxConstraints(minHeight: 310),
                      decoration: BoxDecoration(
                        color: classic ? const Color(0xFFEAEAF2) : null,
                        gradient: classic ? null : ShopColors.gradient,
                      ),
                      child: Stack(
                        children: [
                          if (!classic)
                            Positioned(
                              right: -70,
                              top: -70,
                              child: Opacity(
                                opacity: .15,
                                child: Image.asset(
                                  'assets/images/contours.png',
                                  width: 300,
                                ),
                              ),
                            ),
                          ShopHeader(controller, light: !classic),
                          if (!classic)
                            Positioned(
                              left: 34,
                              top: 103,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 31,
                                      color: Colors.white,
                                      height: 1.15,
                                    ),
                                  ),
                                  const Text(
                                    'Women',
                                    style: TextStyle(
                                      fontSize: 31,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Rating(white: true),
                                  const SizedBox(height: 47),
                                  InkWell(
                                    onTap: () => _colourPicker(context),
                                    child: Row(
                                      children: [
                                        Text(
                                          p.colour,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: p.swatch,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Size  ',
                                          style: TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '12cm',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (classic)
                            const Positioned(
                              left: 110,
                              right: 90,
                              bottom: 40,
                              child: _ProductShadow(),
                            ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ShopColors.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              right: classic ? 37 : null,
                              left: classic ? null : 34,
                              top: -24,
                              child: HeartButton(controller, p),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                classic ? 29 : 34,
                                classic ? 35 : 75,
                                29,
                                10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (classic) ...[
                                    Text(
                                      p.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    const Rating(),
                                    const SizedBox(height: 9),
                                  ] else
                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF85858B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  const Text(
                                    description,
                                    style: TextStyle(
                                      color: Color(0xFFAAAAAF),
                                      fontSize: 13,
                                      height: 1.8,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (classic) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => _colourPicker(context),
                                            child: Container(
                                              height: 49,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    p.colour == 'Red'
                                                        ? 'Pink'
                                                        : p.colour,
                                                    style: const TextStyle(
                                                      color: ShopColors.muted,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    radius: 7,
                                                    backgroundColor: p.swatch,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Container(
                                            height: 49,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Size  ',
                                                    style: TextStyle(
                                                      color: ShopColors.muted,
                                                    ),
                                                  ),
                                                  TextSpan(text: '12cm'),
                                                ],
                                              ),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 29),
                                  ] else
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Quantity',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'Price',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      QuantityStepper(
                                        value: controller.quantity,
                                        onChanged: controller.setQuantity,
                                        filled: classic,
                                      ),
                                      Price(
                                        p.price * controller.quantity,
                                        size: 34,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!classic)
                              const Positioned(
                                right: 45,
                                top: 40,
                                width: 145,
                                child: _ProductShadow(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(9),
            ),
            child: classic
                ? Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            controller.addToCart();
                            showNotice(context, '${p.name} added to cart');
                          },
                          child: const Text(
                            'Add Card +',
                            style: TextStyle(
                              color: ShopColors.ink,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        height: 51,
                        child: IconButton.filled(
                          tooltip: 'View cart',
                          style: IconButton.styleFrom(
                            backgroundColor: ShopColors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () {
                            controller.addToCart();
                            controller.go(AppScreen.cart);
                          },
                          icon: const Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (controller.screen == AppScreen.productGreen) ...[
                        Price(p.price * controller.quantity),
                        const SizedBox(width: 18),
                      ],
                      Expanded(
                        child: ShopButton(
                          'Buy Now',
                          icon: Icons.shopping_basket_outlined,
                          onPressed: () {
                            controller.addToCart();
                            controller.go(AppScreen.cart);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _colourPicker(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: ShopColors.background,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose colour',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 12,
            children: products
                .take(4)
                .map(
                  (p) => ActionChip(
                    avatar: CircleAvatar(backgroundColor: p.swatch, radius: 8),
                    label: Text(p.colour),
                    onPressed: () {
                      Navigator.pop(context);
                      controller.openProduct(p);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}

class _ProductShadow extends StatelessWidget {
  const _ProductShadow();
  @override
  Widget build(BuildContext context) => Container(
    height: 10,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.elliptical(100, 10)),
      boxShadow: [
        BoxShadow(color: Color(0x55585574), blurRadius: 14, spreadRadius: 2),
      ],
    ),
  );
}

class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFADACBE), ShopColors.tile, Color(0xFFD7D7E0)],
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(38, 42, 23, 0),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Rating(white: true),
                    Text(
                      'Blue Bag Women',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Open bag details',
                onPressed: () => controller.openProduct(products[0]),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: SizedBox(
              width: 145,
              height: 140,
              child: CustomPaint(painter: _ScanPainter()),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white38, width: 5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 55,
                  decoration: BoxDecoration(
                    color: ShopColors.tile,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Awesome Bag',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Rating(),
                    ],
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Add Awesome Bag',
                  style: IconButton.styleFrom(
                    backgroundColor: ShopColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    controller.addToCart(products[0]);
                    controller.go(AppScreen.cart);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ScanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (final x in [0.0, size.width]) {
      for (final y in [0.0, size.height]) {
        canvas.drawLine(Offset(x, y), Offset(x == 0 ? 23 : x - 23, y), pen);
        canvas.drawLine(Offset(x, y), Offset(x, y == 0 ? 23 : y - 23), pen);
      }
    }
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawCircle(
        Offset(x, size.height / 2),
        1.5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
