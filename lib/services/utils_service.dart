import 'package:flutter/material.dart';

String titleCase(String s) => s
    .split(RegExp(r'[-_ ]+'))
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

IconData iconForCategory(String c) {
  final k = c.toLowerCase();
  if (k.contains('smart') || k.contains('phone') || k.contains('mobile')) return Icons.smartphone;
  if (k.contains('laptop')) return Icons.laptop_mac;
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
