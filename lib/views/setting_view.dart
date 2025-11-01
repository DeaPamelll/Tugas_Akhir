import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/views/admin_view.dart';
import 'package:tugas_akhir/views/profil_view.dart';

import 'widgets/header_widget.dart';
import 'widgets/footer_widget.dart';
import '../services/auth_service.dart';
import '../controllers/k_waktu_controller.dart';
import 'login_view.dart';
import 'toko_view.dart';
import 'saran_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  static const rose = Color(0xFFE8A0BF);

  Future<void> _logout(BuildContext context) async {
    final auth = AuthService();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await auth.logout();

    Get.snackbar(
      'Logout Berhasil',
      'Sampai jumpa lagi!',
      backgroundColor: Colors.pink.shade100,
      colorText: Colors.black,
    );

    Get.offAll(() => LoginView());
  }

  @override
  Widget build(BuildContext context) {
    final waktu = Get.find<KWaktuController>();

    return Scaffold(
      appBar: const HeaderWidget(title: 'Pengaturan'),
      bottomNavigationBar: const FooterWidget(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Menu Pengaturan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          // ====== PROFIL ======
          _SettingTile(
            icon: Icons.person_outline,
            title: 'Profil Saya',
            subtitle: 'Lihat & ubah informasi akun',
            onTap: () => Get.to(() => const ProfileView()),
          ),

          // ====== TOKO / LBS ======
          _SettingTile(
            icon: Icons.storefront_outlined,
            title: 'Toko Kami (LBS)',
            subtitle: 'Lihat lokasi toko & layanan terdekat',
            onTap: () => Get.to(() => const TokoView()),
          ),

          // ====== SARAN ======
          _SettingTile(
            icon: Icons.feedback_outlined,
            title: 'Saran & Masukan',
            subtitle: 'Kirimkan ide dan pendapatmu tentang aplikasi ini',
            onTap: () => Get.to(() => const SaranView()),
          ),

            _SettingTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Admin',
            subtitle: 'Lihat Profil Admin',
            onTap: () => Get.to(() => const AdminView()),
          ),


          const SizedBox(height: 20),

          // ====== ZONA WAKTU ======
          const Text(
            'Zona Waktu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final nowPreview = waktu.formatDate(DateTime.now());
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: rose),
                  const SizedBox(width: 10),
                  const Text('Zona: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: waktu.selectedZone.value,
                      items: const [
                        DropdownMenuItem(value: 'WIB', child: Text('WIB')),
                        DropdownMenuItem(value: 'WITA', child: Text('WITA')),
                        DropdownMenuItem(value: 'WIT', child: Text('WIT')),
                        DropdownMenuItem(value: 'London', child: Text('London')),
                      ],
                      onChanged: (v) {
                        if (v != null) waktu.setZone(v);
                      },
                    ),
                  ),
                  const Spacer(),
                  Text(nowPreview, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // ====== LOGOUT ======
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE8A0BF)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
