# 开发验证记录

验证日期：**2026-10-29（Asia/Tokyo）**。

## 环境

| 项目 | 实际使用 |
| --- | --- |
| Flutter / Dart | 3.41.6 / 3.11.4 |
| 开发系统 | macOS ARM64 |
| Android 模拟器 | Kino_API_35，API 35，ARM64 |
| 模拟器截图 | 1125 × 2436，21 页 + 购物流程结束与 Release 冷启动各 1 张 |
| 页面渲染基线 | 375 px 宽，按 Pixso 对应画板高度保存 |
| 小屏与大屏 | 320 × 640、430 × 932 逻辑像素 |

## 结果

| 检查 | 结果 | 覆盖内容 |
| --- | --- | --- |
| `flutter analyze` | 通过，无问题 | 业务代码、测试代码 |
| `flutter test` | 27 项通过 | 3 个状态逻辑测试、21 个页面截图、2 组全页宽度适配、1 个界面交互测试 |
| Android 集成测试 | 通过 | 21 页实际渲染、截图保存、登录、加购、添加卡片、结算完成 |
| Android Release APK | 构建通过 | 单独输出 ARM64 包，约 18 MB |
| Release 安装与冷启动 | 通过 | 模拟器安装成功，Activity 启动状态 ok，正常展示欢迎页 |
| Web Release | 构建通过 | Web 编译及 Wasm 兼容性预检查 |
| iOS | 未运行 | 已保留平台工程；本机无可用 iOS Simulator runtime |

Android 流程使用用户名 `Demo Shopper`、密码 `demo123` 登录，选择红色商品，将数量加到 2 后加入购物车；输入演示卡片，返回购物车，点击 Buy Now。断言已保存尾号 `4242`、页面进入 Timeline、购物车清空，并保存 [最终截图](screenshots/android/22-checkout-complete.png)。该过程没有真实支付。

金额测试同时验证初始 4 件共 $78、加购/减量/删除后的总价变化和结算清空。检索测试验证关键词、价格、分类、颜色和排序；页面测试检查所有设计状态无布局异常。截图基线用于回归比较，不代表与 Pixso 自动逐像素相等。

## 复现

```bash
flutter pub get
flutter analyze
flutter test

# 先在 Android Studio 启动模拟器，或运行 flutter emulators --launch <名称>
flutter devices
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d emulator-5554

flutter build apk --release --target-platform android-arm64 --split-per-abi
flutter build web
```

集成测试会将截图写入 `docs/screenshots/android/`。原稿尺寸截图由 `flutter test --update-goldens` 更新，首次修改设计后应人工检查图片再接受基线。

集成测试的构建会使用测试入口。测试结束后需要运行普通 `flutter run` 或安装 `dist/getshop-android-arm64.apk` 以体验正常 App。
