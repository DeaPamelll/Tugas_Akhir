import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const rose     = Color(0xFFE8A0BF);
  static const lightBg  = Color(0xFFFFF8F9);
  static const ivory    = Color(0xFFFFF8F0);
  static const card     = Colors.white;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.6,
        backgroundColor: card,
        surfaceTintColor: card,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: rose),
          );
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text("User tidak ditemukan"));
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              children: [
                // ================================
                // FOTO PROFIL
                // ================================
                GestureDetector(
                  onTap: controller.openEditProfileView,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFE2EE), Color(0xFFF8CFE1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: rose.withOpacity(.20),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor: card,
                      child: ClipOval(
                        child: (user.photoPath != null &&
                                user.photoPath!.isNotEmpty)
                            ? Image.file(
                                File(user.photoPath!),
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              )
                            : const Icon(
                                Icons.person,
                                size: 85,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ================================
                // USERNAME
                // ================================
                Text(
                  user.username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 6),

                // ================================
                // EMAIL
                // ================================
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _InfoChip(
                      icon: Icons.alternate_email_rounded,
                      label: user.email,
                    ),
                  ],
                ),


                const SizedBox(height: 14),

                // ================================
                // HOBBY
                // ================================
                _ThinCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle("Hobi"),
                      const SizedBox(height: 10),
                      _HobbyWrap(items: user.hobbies ?? []),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================================
                // TOMBOL EDIT PROFIL
                // ================================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rose,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: controller.openEditProfileView,
                  child: const Text(
                    "Edit Profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================================
                // TOMBOL HAPUS AKUN (dengan konfirmasi)
                // ================================
                TextButton(
                  onPressed: () => showDeleteConfirmation(context, controller),
                  child: const Text(
                    "Hapus Akun",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  // =======================================================
  // KONFIRMASI HAPUS AKUN
  // =======================================================
  void showDeleteConfirmation(BuildContext context, ProfileController c) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus Akun"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus akun ini?\n"
          "Tindakan ini tidak dapat dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              c.deleteAccount();
            },
            child: const Text(
              "Ya, Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================
// WIDGETS
// ================================

class _ThinCard extends StatelessWidget {
  const _ThinCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: ProfileView.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }
}

Widget _InfoChip({
  required IconData icon,
  required String label,
  Color iconColor = Colors.pink,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
        color: Colors.black87,
      ),
    );
  }
}

class _HobbyWrap extends StatelessWidget {
  const _HobbyWrap({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text(
        "Belum menambahkan hobi",
        style: TextStyle(color: Colors.black54),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ProfileView.rose.withOpacity(.22)),
              ),
              child: Text(
                e,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
