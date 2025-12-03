import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/views/transaksi_view.dart';
import '../../controllers/cart_controller.dart';
import '../home.dart';
import '../setting_view.dart';


class FooterWidget extends StatelessWidget {
  final int currentIndex;

  const FooterWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        final badge = cart.distinctCount; 

        return BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFFE8A0BF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            if (i == currentIndex) return;

            switch (i) {
              case 0:
                Get.offAll(() => HomeView());
                break;
              case 1:
                Get.offAll(() => const TransaksiView());
                break;
              case 2:
                Get.offAll(() => SettingView());
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              label: 'Belanja',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.settings_outlined),
                  if (badge > 0)
                    Positioned(
                      right: -6,
                      top: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Setting',
            ),
          ],
        );
      },
    );
  }
}
