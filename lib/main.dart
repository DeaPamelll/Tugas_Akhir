import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'controllers/cart_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'controllers/k_mata_uang_controller.dart';
import 'controllers/transaksi_controller.dart';
import 'controllers/k_waktu_controller.dart';
import 'services/k_mata_uang_service.dart';
import 'services/notification_service.dart';
import 'models/user_model.dart';
import 'models/cart_item.dart';
import 'models/product.dart';
import 'models/transaction_model.dart';
import 'models/transaction_model.g.dart';
import 'views/landing_view.dart';
import 'views/transaksi_view.dart';
import 'views/checkout_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  // ===== REGISTER ADAPTERS =====
  if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
    Hive.registerAdapter(UserAdapter());
  }
  if (!Hive.isAdapterRegistered(CartItemAdapter().typeId)) {
    Hive.registerAdapter(CartItemAdapter());
  }
  if (!Hive.isAdapterRegistered(ProductAdapter().typeId)) {
    Hive.registerAdapter(ProductAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  // ===== OPEN BOXES =====
  await Hive.openBox('session');                        // sesi login
  await Hive.openBox<User>('users');                    // storage user
  await Hive.openBox<CartItem>('cart_guest');           // keranjang default guest
  await Hive.openBox<TransactionModel>('transactions'); // transaksi
  await Hive.openBox('prefs');                          // preferensi (zona waktu, dsb)

  // ===== INIT NOTIFICATIONS =====
  await NotificationService.initialize();

  // ===== REGISTER CONTROLLERS (permanent) =====
  if (!Get.isRegistered<KMataUangController>()) {
    Get.put(KMataUangController(KMataUangService()), permanent: true);
  }
  if (!Get.isRegistered<KWaktuController>()) {
    Get.put(KWaktuController(), permanent: true);
  }
  if (!Get.isRegistered<CartController>()) {
    Get.put(CartController(), permanent: true);
  }
  if (!Get.isRegistered<WishlistController>()) {
    Get.put(WishlistController(), permanent: true);
  }
  if (!Get.isRegistered<TransaksiController>()) {
    Get.put(TransaksiController(), permanent: true);
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "D'Shop",
    home: LandingView(), 
    getPages: [
      GetPage(name: '/transaksi', page: () => const TransaksiView()),
      GetPage(name: '/checkout', page: () => const CheckoutView()),
    ],
  ));
}
