import 'package:flutter/material.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) {
    final screen = controller.screen;
    final welcome = screen == AppScreen.welcome;
    final dark = screen == AppScreen.onboardingDark;
    final confirmed = screen == AppScreen.confirmation;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: welcome ? ShopColors.background : null,
        gradient: welcome
            ? null
            : dark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF746DFD), Color(0xFF3441AA)],
              )
            : confirmed
            ? ShopColors.gradient
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFA093FD), Color(0xFFB0A7EE)],
              ),
      ),
      child: LayoutBuilder(
        builder: (context, bounds) => Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 375,
              height: 812,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  if (welcome) ...[
                    Positioned(
                      left: -23,
                      top: -50,
                      child: Image.asset(
                        'assets/images/contours.png',
                        width: 303,
                        height: 356,
                      ),
                    ),
                    Positioned(
                      left: 67,
                      top: 92,
                      child: Image.asset(
                        'assets/images/welcome-woman.png',
                        width: 233,
                        height: 326,
                      ),
                    ),
                    Positioned(left: 292, top: 35, child: _dots(0, false)),
                    const Positioned(
                      left: 32,
                      top: 468,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Great Job!\n',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: 'getshop\nawesome app',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 36,
                          height: 1.15,
                          color: ShopColors.ink,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 32,
                      top: 615,
                      width: 279,
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.8,
                          color: Color(0xFFABABAF),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 27,
                      right: 28,
                      bottom: 24,
                      child: ShopButton(
                        'Start Shoping',
                        height: 72,
                        onPressed: () =>
                            controller.go(AppScreen.onboardingDark),
                      ),
                    ),
                  ] else if (dark) ...[
                    Positioned(
                      left: -152,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/city.png',
                        width: 653,
                        height: 444,
                      ),
                    ),
                    Positioned(left: 33, top: 39, child: _dots(1, true)),
                    const Positioned(
                      left: 27,
                      top: 97,
                      child: Text(
                        'We are here\n24 hours\nare working',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 28,
                      top: 224,
                      width: 279,
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.white54,
                          height: 1.8,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 27,
                      top: 310,
                      child: SizedBox(
                        width: 79,
                        height: 79,
                        child: FilledButton(
                          onPressed: () =>
                              controller.go(AppScreen.onboardingProducts),
                          style: FilledButton.styleFrom(
                            backgroundColor: ShopColors.pink,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Start'),
                              Icon(Icons.east, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 14,
                      child: TextButton(
                        onPressed: () =>
                            controller.go(AppScreen.onboardingProducts),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ] else if (confirmed) ...[
                    Positioned(
                      left: -160,
                      bottom: -40,
                      child: Opacity(
                        opacity: .15,
                        child: Image.asset(
                          'assets/images/contours.png',
                          width: 450,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 114,
                      top: 206,
                      child: Image.asset(
                        'assets/images/mail.png',
                        width: 139,
                        height: 139,
                      ),
                    ),
                    const Positioned(
                      left: 25,
                      right: 25,
                      top: 391,
                      child: Text(
                        'Confirmation mail\nfor the product',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(left: 157, top: 527, child: _dots(3, true)),
                    Positioned(
                      left: 140,
                      right: 16,
                      bottom: 15,
                      child: ShopButton(
                        'Start Shoping',
                        onPressed: () => controller.go(AppScreen.home),
                        color: Colors.transparent,
                      ),
                    ),
                  ] else ...[
                    Positioned(
                      left: 165,
                      top: 271,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: ShopColors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 12,
                      right: 12,
                      top: 334,
                      child: Text(
                        'Thousands of\nproducts you may like',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(left: 157, top: 527, child: _dots(2, true)),
                    Positioned(
                      left: 24,
                      right: 31,
                      bottom: 117,
                      child: ShopButton(
                        'Login Getshop',
                        outlined: true,
                        height: 72,
                        onPressed: () => controller.go(AppScreen.login),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 31,
                      bottom: 31,
                      child: ShopButton(
                        'Sing up Getshop',
                        color: ShopColors.pink,
                        height: 72,
                        onPressed: () => controller.go(AppScreen.signup),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dots(int active, bool white) => Row(
    children: List.generate(
      4,
      (i) => Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Container(
          width: i == active ? 28 : 5,
          height: 3,
          decoration: BoxDecoration(
            color: i == active
                ? ShopColors.pink
                : white
                ? Colors.white54
                : ShopColors.muted,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ),
  );
}
