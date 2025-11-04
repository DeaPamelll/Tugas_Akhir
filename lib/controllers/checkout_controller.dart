import 'package:get/get.dart';
import '../models/cart_item.dart';
import 'k_mata_uang_controller.dart';

class CheckoutController extends GetxController {
  final List<CartItem> items;

  CheckoutController({required this.items});

  final RxString payment = 'COD'.obs;
  final RxString courier = 'JNE'.obs;

  
  final KMataUangController curr = Get.find<KMataUangController>();

  double get totalUsd =>
      items.fold<double>(0.0, (a, e) => a + (e.price.toDouble() * e.qty));

  double get fx => curr.factorFromUsdTo(curr.selected.value);

  double get totalFx => totalUsd * fx;

  List<String> get paymentMethods => const ['COD', 'Transfer Bank', 'E-Wallet'];
  List<String> get couriers => const ['JNE', 'J&T', 'SiCepat', 'AnterAja'];
}
