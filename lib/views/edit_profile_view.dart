import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.find<ProfileController>();

  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  String? newImagePath;

  List<String> allHobbies = [
    "Membaca",
    "Gaming",
    "Traveling",
    "Hiking",
    "Singing",
    "Cooking",
  ];

  List<String> selectedHobbies = [];

  static const rose     = Color(0xFFE8A0BF);
  static const card     = Colors.white;
  static const lightBg  = Color(0xFFFFF8F9);

  @override
  void initState() {
    super.initState();
    final user = controller.user.value!;
    usernameC.text = user.username;
    emailC.text = user.email;
    selectedHobbies = List.from(user.hobbies ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.user.value!;

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.6,
        backgroundColor: card,
        surfaceTintColor: card,
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
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
                      child: _buildProfileImage(user),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () => _showImagePicker(),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: rose,
                        boxShadow: [
                          BoxShadow(
                            color: rose.withOpacity(.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 28),

          _label("Username"),
          _input(usernameC),

          const SizedBox(height: 22),

          _label("Email"),
          _input(emailC),

          const SizedBox(height: 22),

          _label("Password (opsional)"),
          _input(passwordC, obscure: true),

          const SizedBox(height: 28),

          _label("Hobi"),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: allHobbies.map((hobby) {
              bool selected = selectedHobbies.contains(hobby);
              return FilterChip(
                label: Text(
                  hobby,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                selected: selected,
                selectedColor: rose.withOpacity(.25),
                checkmarkColor: Colors.white,
                onSelected: (_) {
                  setState(() {
                    selected
                        ? selectedHobbies.remove(hobby)
                        : selectedHobbies.add(hobby);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 38),

          ElevatedButton(
            onPressed: () async {
              bool ok = await controller.updateProfile(
                username: usernameC.text,
                email: emailC.text,
                password: passwordC.text.isEmpty
                    ? null
                    : passwordC.text.trim(),
                hobbies: selectedHobbies,
                imagePath: newImagePath,
              );

              if (ok) {
                Get.back();
                Get.snackbar(
                  "Berhasil",
                  "Profil diperbarui",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: rose,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Simpan Perubahan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileImage(user) {
    ImageProvider? imageProvider;

    if (newImagePath != null) {
      imageProvider = FileImage(File(newImagePath!));
    } else if (user.photoPath != null && user.photoPath!.isNotEmpty) {
      imageProvider = FileImage(File(user.photoPath!));
    }

    if (imageProvider != null) {
      return Image(
        image: imageProvider,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    return const Icon(
      Icons.person,
      size: 85,
      color: Colors.grey,
    );
  }

  // ======================
  // INPUT & LABEL WIDGETS
  // ======================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: .2,
      ),
    );
  }

  Widget _input(TextEditingController c, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(.1)),
      ),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ==========================
  // PHOTO PICKER
  // ==========================

  void _showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: rose),
              title: const Text("Pilih dari Galeri"),
              onTap: () async {
                final path = await controller.pickImageGallery();
                if (path != null) setState(() => newImagePath = path);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: rose),
              title: const Text("Ambil dari Kamera"),
              onTap: () async {
                final path = await controller.pickImageCamera();
                if (path != null) setState(() => newImagePath = path);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
