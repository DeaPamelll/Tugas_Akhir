import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controllers/cart_controller.dart';
import 'package:tugas_akhir/controllers/transaksi_controller.dart';
import 'package:tugas_akhir/views/home.dart'; 
import 'package:tugas_akhir/views/admin_dashboard_view.dart';
import 'package:tugas_akhir/views/login_view.dart'; 
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

      final email = emailController.text;
      final password = passwordController.text;

      final isAdminLogin = await _authService.loginAdmin(
        email: email,
        password: password,
      );

      if (isAdminLogin) {
        isLoading.value = false;
        Get.snackbar(
          "Login Berhasil",
          "Anda masuk sebagai Administrator.", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.indigo,
          colorText: Colors.white,
        );
        
        Get.offAll(() => AdminDashboardView());
        return;
      }

      final result = await _authService.loginUser(
        email: email,
        password: password,
      );

      isLoading.value = false;

      if (result.startsWith("SuccessUser")) {
        Get.snackbar(
          "Login Berhasil",
          "Selamat datang kembali!", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        
        final uid = await _authService.currentUserId();

        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().setActiveUser(uid);
        }
        if (Get.isRegistered<TransaksiController>()) {
          Get.find<TransaksiController>().setActiveUser(uid);
        }

        Get.offAll(() => HomeView());
      } else {
        Get.snackbar(
          "Login Gagal",
          result.replaceAll("Error: ", ""), 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
  
  Future<void> doLogout() async {
    await _authService.logout();
    Get.offAll(() => LoginView()); 
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}