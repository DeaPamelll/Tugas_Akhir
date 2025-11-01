import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_service.dart';
// Impor view login untuk navigasi
import '../views/login_view.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  // GlobalKey untuk Form
  final formKey = GlobalKey<FormState>();

  // Controllers untuk text field
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs; // Untuk status loading

  // Validator untuk email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!EmailValidator.validate(value)) {
      return "Format email tidak valid (cth: a@b.com)";
    }
    return null;
  }

  // Validator untuk password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  // Validator untuk konfirmasi password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    if (value != passwordController.text) {
      return "Password tidak cocok";
    }
    return null;
  }

  // Fungsi yang dipanggil saat tombol register ditekan
  void doRegister() async {
    // 1. Validasi form
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Mulai loading

      // 2. Panggil service
      final result = await _authService.registerUser(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      isLoading.value = false; // Selesai loading

      // 3. Tampilkan hasil
      if (result.startsWith("Success")) {
        Get.snackbar(
          "Sukses",
          "Registrasi berhasil, silahkan login.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Pindah ke halaman login
        Get.off(() => LoginView()); // 'off' agar tidak bisa kembali ke register
      } else {
        Get.snackbar(
          "Gagal",
          result, // Tampilkan pesan error dari service
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    // Bersihkan controller saat halaman ditutup
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}