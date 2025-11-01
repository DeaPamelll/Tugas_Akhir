import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    const ivory = Color(0xFFFFF8F0);
    const blush = Color(0xFFFFDDE1);
    const rose  = Color(0xFFE8A0BF);

    return Scaffold(
      backgroundColor: ivory,
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: blush,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container
          (
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: rose.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Selamat Datang 💗",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: rose,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email
                  _coquetteField(
                    controller: controller.emailController,
                    label: "Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? "Email tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Password (show/hide)
                  Obx(() {
                    return _coquetteField(
                      controller: controller.passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscure: !controller.isPasswordVisible.value,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Password tidak boleh kosong" : null,
                      suffix: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: rose,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Login button
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.doLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rose,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              shadowColor: rose.withOpacity(0.4),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                  }),

                  const SizedBox(height: 24),

                  // Belum punya akun? Daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => Get.to(() => RegisterView()),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            color: rose,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable coquette text field
  Widget _coquetteField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: inputType,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE8A0BF)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFFFF8F9),
        labelStyle: const TextStyle(color: Color(0xFFB07293)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFC0CB), width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE8A0BF), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
