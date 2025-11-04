import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  static final page = Colors.grey.shade50;
  static const card = Colors.white;

  Future<String?> _loadEmail() async {
    try {
      return await AuthService().currentEmail(); // <-- pakai currentEmail()
    } catch (_) {
      return null;
    }
  }

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
      backgroundColor: page,
      appBar: const HeaderWidget(title: 'Setting'),
      bottomNavigationBar: const FooterWidget(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Header Profil (ikon tengah + email) =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12.withOpacity(.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: rose.withOpacity(.15),
                  child: const Icon(Icons.person_rounded, size: 80, color: rose),
                ),
                const SizedBox(height: 10),
                FutureBuilder<String?>(
                  future: _loadEmail(),
                  builder: (context, snap) {
                    final email = snap.data;
                    return Text(
                      email?.isNotEmpty == true ? email! : 'email@pengguna.com',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ===== Menu =====
          const Text(
            'Menu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          _PlainTile(
            icon: Icons.person_outline,
            title: 'Profil Admin',
            onTap: () => Get.to(() => const ProfileView()),
          ),
          _PlainTile(
            icon: Icons.storefront_outlined,
            title: 'Toko Kami',
            onTap: () => Get.to(() => const TokoView()),
          ),
          _PlainTile(
            icon: Icons.feedback_outlined,
            title: 'Kesan & Pesan',
            onTap: () => Get.to(() => const SaranView()),
          ),

          const SizedBox(height: 20),

          // ===== Zona Waktu =====
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
                color: card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12.withOpacity(.10)),
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

          // ===== Logout =====
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

class _PlainTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PlainTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: SettingView.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12.withOpacity(.10)),
      ),
      child: ListTile(
        leading: Icon(icon, color: SettingView.rose),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
