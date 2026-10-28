import 'package:flutter/material.dart';
import '../state/shop_controller.dart';
import '../theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen(this.controller, {super.key});
  final ShopController controller;
  void _info(BuildContext context, String title, String content) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: ShopColors.gradient),
    child: LayoutBuilder(
      builder: (context, bounds) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -160,
            bottom: -30,
            child: Opacity(
              opacity: .15,
              child: Image.asset('assets/images/contours.png', width: 450),
            ),
          ),
          Positioned(
            left: bounds.maxWidth * .47,
            top: bounds.maxHeight * .13,
            child: GestureDetector(
              onTap: () => controller.go(AppScreen.favorites),
              child: Image.asset(
                'assets/images/menu-preview.png',
                width: 399,
                height: 652,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 32,
            right: 45,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    width: 53,
                    height: 49,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.userEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 36,
            right: 16,
            child: IconButton(
              tooltip: 'Close menu',
              onPressed: controller.back,
              icon: const Icon(Icons.close, size: 19, color: Colors.white),
            ),
          ),
          Positioned(
            top: bounds.maxHeight * .3,
            left: 21,
            width: bounds.maxWidth * .43,
            bottom: 100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _item(
                    Icons.home,
                    'Home',
                    () => controller.go(AppScreen.home),
                    active: true,
                  ),
                  _item(
                    Icons.bookmark_outline,
                    'Saved Items',
                    () => controller.go(AppScreen.favorites),
                  ),
                  _item(
                    Icons.settings_outlined,
                    'App Settings',
                    () => _info(
                      context,
                      'App Settings',
                      'Getshop · Version 1.0.0\n\nDemo mode\nCurrency: USD\nLanguage: English\nYour shopping session stays on this device while the app is open.',
                    ),
                  ),
                  _item(
                    Icons.shopping_bag_outlined,
                    'Product',
                    () => controller.go(AppScreen.explore),
                  ),
                  _item(
                    Icons.account_circle_outlined,
                    'Profile',
                    () => _info(
                      context,
                      'Profile',
                      '${controller.userName}\n${controller.userEmail}\n\n${controller.signedIn ? 'Signed in to the local demo.' : 'You are browsing as a guest.'}',
                    ),
                  ),
                  _item(
                    Icons.account_balance_wallet_outlined,
                    'Wallet',
                    () => controller.go(AppScreen.addCard),
                  ),
                  _item(
                    Icons.help_outline,
                    'Help & FAQs',
                    () => _info(
                      context,
                      'Help & FAQs',
                      'How do I shop?\nOpen Product, choose a bag and tap Buy Now.\n\nWhere are my saved items?\nOpen Saved Items to manage favorites.\n\nDoes checkout charge me?\nThis is a local UI demo. No payment is processed.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 23,
            bottom: 50,
            child: TextButton.icon(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout, color: Colors.white, size: 19),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Widget _item(
    IconData icon,
    String title,
    VoidCallback action, {
    bool active = false,
  }) => SizedBox(
    height: 46,
    child: TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        foregroundColor: active ? Colors.white : Colors.white54,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );
}
