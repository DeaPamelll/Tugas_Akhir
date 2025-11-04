import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_service.dart';
import '../views/login_view.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs; 

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!EmailValidator.validate(value)) {
      return "Format email tidak valid (cth: a@b.com)";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    if (value != passwordController.text) {
      return "Password tidak cocok";
    }
    return null;
  }


  void doRegister() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; 

      final result = await _authService.registerUser(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      isLoading.value = false; 

      if (result.startsWith("Success")) {
        Get.snackbar(
          "Sukses",
          "Registrasi berhasil, silahkan login.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.off(() => LoginView()); 
      } else {
        Get.snackbar(
          "Gagal",
          result, 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}