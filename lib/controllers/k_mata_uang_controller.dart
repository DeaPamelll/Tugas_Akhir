import 'package:get/get.dart';
import '../services/k_mata_uang_service.dart';

class KMataUangController extends GetxController {
  final KMataUangService service;
  KMataUangController(this.service);

  final rates = <String, double>{}.obs;
  final selected = 'USD'.obs;       
  final loading = true.obs;
  final error = RxnString();

  final allowed = const ['USD', 'IDR', 'EUR', 'JPY'];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      loading.value = true;
      error.value = null;
      final r = await service.fetchRates(); 
      rates.assignAll(r);

      if (!allowed.contains(selected.value)) selected.value = 'USD';
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  double factorFromUsdTo(String code) => rates[code] ?? 1.0;

  List<String> dropdownCodes() =>
      allowed.where((c) => c == 'USD' || rates.containsKey(c)).toList();
}
