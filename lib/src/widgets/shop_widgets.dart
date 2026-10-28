import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_controller.dart';
import '../theme.dart';

const description =
    'It is a long established fact that a reader will be distracted by the readable content of a page';

class ShopButton extends StatelessWidget {
  const ShopButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.color = ShopColors.purple,
    this.outlined = false,
    this.height = 64,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool outlined;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: outlined ? Colors.transparent : color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: ShopColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: outlined
              ? const BorderSide(color: Colors.white38)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 24),
            Icon(icon, size: 23),
          ],
        ],
      ),
    ),
  );
}

class ShopHeader extends StatelessWidget {
  const ShopHeader(
    this.controller, {
    super.key,
    this.back = false,
    this.light = false,
  });
  final ShopController controller;
  final bool back;
  final bool light;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 30, 18, 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: back ? 'Back' : 'Menu',
          onPressed: back
              ? controller.back
              : () => controller.go(AppScreen.menu),
          icon: Icon(
            back ? Icons.west : Icons.notes,
            size: 21,
            color: light ? Colors.white : const Color(0xFF8C8C8D),
          ),
        ),
        Semantics(
          label: 'Cart, ${controller.cartCount} items',
          button: true,
          child: InkWell(
            key: const Key('open-cart'),
            borderRadius: BorderRadius.circular(5),
            onTap: () => controller.go(AppScreen.cart),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 35,
                  decoration: BoxDecoration(
                    color: light ? Colors.white : ShopColors.purple,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.shopping_basket_outlined,
                    size: 19,
                    color: light ? ShopColors.purple : Colors.white,
                  ),
                ),
                if (controller.cartCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: light ? ShopColors.pink : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: ShopColors.purple),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: .5,
      ),
    ),
  );
}

class Price extends StatelessWidget {
  const Price(this.amount, {super.key, this.size = 24, this.white = false});
  final int amount;
  final double size;
  final bool white;
  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.top,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, right: 3),
            child: Text(
              '\$',
              style: TextStyle(
                color: white ? Colors.white : ShopColors.purple,
                fontSize: size * .5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        TextSpan(
          text: '$amount',
          style: TextStyle(
            fontSize: size,
            color: white ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: -.8,
          ),
        ),
      ],
    ),
  );
}

class Rating extends StatelessWidget {
  const Rating({super.key, this.white = false});
  final bool white;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.star_rounded,
        size: 17,
        color: white ? Colors.white : const Color(0xFFFF7A87),
      ),
      const SizedBox(width: 3),
      Text(
        '4,5',
        style: TextStyle(
          color: white ? Colors.white : const Color(0xFF97979B),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    ],
  );
}

class ProductTile extends StatelessWidget {
  const ProductTile(
    this.product,
    this.controller, {
    super.key,
    this.favorite = false,
    this.height = 158,
  });
  final Product product;
  final ShopController controller;
  final bool favorite;
  final double height;
  @override
  Widget build(BuildContext context) => InkWell(
    key: Key('product-${product.id}'),
    onTap: () => controller.openProduct(product),
    borderRadius: BorderRadius.circular(9),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ShopColors.tile,
            borderRadius: BorderRadius.circular(9),
          ),
          child: favorite
              ? Stack(
                  children: [
                    const Positioned(left: 10, top: 9, child: Rating()),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        tooltip: 'Remove ${product.name} from favorites',
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => controller.toggleFavorite(product),
                        icon: const Icon(Icons.close, color: ShopColors.muted),
                      ),
                    ),
                  ],
                )
              : null,
        ),
        const SizedBox(height: 13),
        Text(
          favorite ? product.name : 'Jully Kingston',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: ShopColors.muted),
        ),
        if (!favorite) ...[
          const SizedBox(height: 5),
          Price(product.price, size: 20),
        ],
      ],
    ),
  );
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.filled = false,
  });
  final int value;
  final ValueChanged<int> onChanged;
  final bool filled;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        decoration: BoxDecoration(
          color: filled ? ShopColors.muted : null,
          border: Border.all(
            color: filled ? ShopColors.muted : const Color(0xFFDEDEE5),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            _control(
              Icons.remove,
              'Decrease quantity',
              value > 1 ? () => onChanged(value - 1) : null,
            ),
            Container(
              width: 1,
              height: 32,
              color: filled ? Colors.white38 : const Color(0xFFDEDEE5),
            ),
            _control(
              Icons.add,
              'Increase quantity',
              value < 99 ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ),
      const SizedBox(width: 18),
      Text(
        '$value',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ],
  );
  Widget _control(IconData icon, String label, VoidCallback? callback) =>
      SizedBox(
        width: 40,
        height: 42,
        child: IconButton(
          key: Key(label),
          tooltip: label,
          onPressed: callback,
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            size: 18,
            color: filled ? Colors.white : ShopColors.muted,
          ),
        ),
      );
}

class HeartButton extends StatelessWidget {
  const HeartButton(this.controller, this.product, {super.key});
  final ShopController controller;
  final Product product;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 44,
    height: 44,
    child: IconButton.filled(
      key: const Key('favorite-toggle'),
      tooltip: controller.favorites.contains(product.id)
          ? 'Remove favorite'
          : 'Save favorite',
      style: IconButton.styleFrom(
        backgroundColor: ShopColors.pink,
        foregroundColor: Colors.white,
      ),
      onPressed: () => controller.toggleFavorite(product),
      icon: Icon(
        controller.favorites.contains(product.id)
            ? Icons.favorite
            : Icons.favorite_border,
        size: 22,
      ),
    ),
  );
}

class GradientBanner extends StatelessWidget {
  const GradientBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.favorite,
    this.pink = false,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final bool pink;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(23),
    decoration: BoxDecoration(
      gradient: pink
          ? const LinearGradient(colors: [Color(0xFFEF6CA8), Color(0xFFFF9ACA)])
          : ShopColors.gradient,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -30,
          top: -100,
          child: Opacity(
            opacity: .15,
            child: Image.asset('assets/images/contours.png', width: 200),
          ),
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: pink ? ShopColors.purple : ShopColors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 21),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
