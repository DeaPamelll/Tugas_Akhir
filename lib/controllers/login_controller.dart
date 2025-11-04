import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controllers/cart_controller.dart';
import 'package:tugas_akhir/controllers/transaksi_controller.dart';
import 'package:tugas_akhir/views/home.dart';
import '../services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs; 

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void doLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      final result = await _authService.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      isLoading.value = false;

      if (result.startsWith("Success")) {
        Get.snackbar(
          "Login Berhasil",
          result, 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        final uid = await _authService.currentUserId();
      Get.find<CartController>().setActiveUser(uid);
      Get.find<TransaksiController>().setActiveUser(uid);

        Get.offAll(() => HomeView());
      } else {
        Get.snackbar(
          "Login Gagal",
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}