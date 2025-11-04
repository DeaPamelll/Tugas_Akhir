import 'package:flutter/material.dart';

String titleCase(String s) => s
    .split(RegExp(r'[-_ ]+'))
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

IconData iconForCategory(String c) {
  final k = c.toLowerCase();
  if (k.contains('smart') || k.contains('phone') || k.contains('mobile')) return Icons.smartphone;
  if (k.contains('tablet')) return Icons.tablet_mac;
  if (k.contains('laptop') || k.contains('notebook')) return Icons.laptop_mac;
  if (k.contains('watch')) return Icons.watch_outlined;
  if (k.contains('camera')) return Icons.photo_camera_outlined;
  if (k.contains('bag') || k.contains('accessor') || k.contains('handbag')) return Icons.shopping_bag_outlined;
  if (k.contains('shoes') || k.contains('footwear')) return Icons.hiking_outlined;
  if (k.contains('tops') || k.contains('dress') || k.contains('fashion') || k.contains('clothing')) return Icons.checkroom_outlined;
  if (k.contains('men') && k.contains('shirt')) return Icons.male_outlined;
  if (k.contains('women') && (k.contains('jewel') || k.contains('earring') || k.contains('necklace'))) return Icons.diamond_outlined;
  if (k.contains('sunglass') || k.contains('glasses')) return Icons.sunny_snowing;
  if (k.contains('beauty') || k.contains('makeup') || k.contains('cosmetic')) return Icons.brush_outlined;
  if (k.contains('fragrance') || k.contains('perfume')) return Icons.spa_outlined;
  if (k.contains('skincare') || k.contains('skin care')) return Icons.face_retouching_natural;
  if (k.contains('grocer') || k.contains('food') || k.contains('drink')) return Icons.local_grocery_store_outlined;
  if (k.contains('home') || k.contains('furn') || k.contains('kitchen')) return Icons.chair_outlined;
  if (k.contains('lighting') || k.contains('lamp')) return Icons.lightbulb_outline;
  if (k.contains('motor') || k.contains('auto') || k.contains('vehicle')) return Icons.electric_bike_outlined;  if (k.contains('laptop')) return Icons.laptop_mac;
  if (k.contains('fragrance') || k.contains('perfume')) return Icons.spa_outlined;
  if (k.contains('skincare')) return Icons.face_retouching_natural;
  if (k.contains('grocer') || k.contains('food')) return Icons.local_grocery_store_outlined;
  if (k.contains('home') || k.contains('furn')) return Icons.chair_outlined;
  if (k.contains('lighting') || k.contains('lamp')) return Icons.lightbulb_outline;
  if (k.contains('watch')) return Icons.watch;
  if (k.contains('bag') || k.contains('accessor')) return Icons.shopping_bag_outlined;
  if (k.contains('shoes')) return Icons.hiking_outlined;
  if (k.contains('tops') || k.contains('dress') || k.contains('fashion')) return Icons.checkroom_outlined;
  if (k.contains('motor') || k.contains('auto')) return Icons.electric_bike_outlined;
  return Icons.category_outlined;
}
