import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  static const Color primaryPink = Color(0xFFE8A0BF);
  static const Color lightPinkBG = Color(0xFFFFF8F9);
  static const Color ivory = Color(0xFFFFF8F0);
  static const Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: ivory,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 0.5),
                  colors: [
                    Color(0xFFFFF0F6),
                    Color(0x00FFF0F6),
                  ],
                ),
              ),
            ),
          ),

          const Positioned(
            top: -30,
            right: -20,
            child: _Bubble(color: Color(0x2DE8A0BF), size: 140),
          ),
          const Positioned(
            top: 90,
            left: -30,
            child: _Bubble(color: Color(0x1FE8A0BF), size: 110),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 50, 24, kb + 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // LOGO
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: primaryPink.withOpacity(.25),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: primaryPink.withOpacity(.35),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 46,
                      color: primaryPink,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(.85),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Masuk untuk melanjutkan belanja",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FORM
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(.78),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryPink.withOpacity(.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          _Input(
                            controller: controller.emailController,
                            label: 'Email',
                            hint: 'nama@email.com',
                            icon: Icons.email_rounded,
                          ),
                          const SizedBox(height: 14),

                          Obx(() => _Input(
                                controller: controller.passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_rounded,
                                obscure: !controller.isPasswordVisible.value,
                                suffix: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: primaryPink,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              )),

                          const SizedBox(height: 10),

                          Obx(() {
                            return controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: primaryPink,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: controller.doLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryPink,
                                        foregroundColor: whiteColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        elevation: 2.5,
                                      ),
                                      child: const Text(
                                        "Masuk",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // PEMBATAS
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black.withOpacity(.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "atau",
                          style: TextStyle(
                            color: Colors.black.withOpacity(.45),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black.withOpacity(.08),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  TextButton(
                    onPressed: () => Get.to(() => const RegisterView()),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryPink,
                    ),
                    child: const Text(
                      "Buat akun baru",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  static const Color primaryPink = _LoginViewState.primaryPink;
  static const Color lightPinkBG = _LoginViewState.lightPinkBG;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (v) =>
          (v == null || v.isEmpty) ? '$label tidak boleh kosong' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryPink),
        suffixIcon: suffix,
        filled: true,
        fillColor: lightPinkBG,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
        hintStyle: TextStyle(color: Colors.black.withOpacity(.35)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryPink.withOpacity(.28)),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryPink, width: 1.6),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 40, spreadRadius: 5),
        ],
      ),
    );
  }
}
