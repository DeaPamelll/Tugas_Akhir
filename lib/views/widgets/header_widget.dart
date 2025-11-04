import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../cart_view.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const HeaderWidget({super.key, this.title});

  static const blush = Color(0xFFFFDDE1);

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return AppBar(
      backgroundColor: blush,
      elevation: 0,
      centerTitle: false,
      title: Text(title ?? "D'Verse", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
      actions: [
        GetBuilder<CartController>( // rebuild saat setActiveUser open box baru
          builder: (_) {
            final count = cart.distinctCount; // item unik (bukan total qty)
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => CartView()),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
