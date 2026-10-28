import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';
import 'src/state/shop_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  const initial = String.fromEnvironment('SCREEN', defaultValue: 'welcome');
  runApp(
    GetshopApp(
      controller: ShopController(initial: AppScreen.fromName(initial)),
    ),
  );
}
