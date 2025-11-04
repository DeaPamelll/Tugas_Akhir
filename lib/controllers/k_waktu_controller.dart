import 'package:get/get.dart';
import 'package:hive/hive.dart';

class KWaktuController extends GetxController {
  static const _boxName = 'prefs';       
  static const _keyTz = 'timezone';     

  final RxString selectedZone = 'WIB'.obs; 
  

  @override
  void onInit() {
    super.onInit();
    _loadSavedZone();
  }

  void _loadSavedZone() {
    final box = Hive.box(_boxName);
    final saved = box.get(_keyTz) as String?;
    if (saved != null) {
      selectedZone.value = saved;
    }
  }

  void setZone(String zone) {
    selectedZone.value = zone;
    Hive.box(_boxName).put(_keyTz, zone);
    update();
  }

  Duration get offset {
    switch (selectedZone.value) {
      case 'WIB': return const Duration(hours: 7);
      case 'WITA': return const Duration(hours: 8);
      case 'WIT': return const Duration(hours: 9);
      case 'London': return const Duration(hours: 0);
      default: return const Duration(hours: 7);
    }
  }

  String formatDate(DateTime utc) {
    final local = utc.toUtc().add(offset);
    return '${local.day.toString().padLeft(2, '0')}-'
           '${local.month.toString().padLeft(2, '0')}-'
           '${local.year} • '
           '${local.hour.toString().padLeft(2, '0')}:'
           '${local.minute.toString().padLeft(2, '0')} ${selectedZone.value}';
  }
}
