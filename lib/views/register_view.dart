import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController controller = Get.put(RegisterController());


  static const Color primaryPink = Color(0xFFE8A0BF); 
  static const Color lightPinkBG = Color(0xFFFFF8F9); 
  static const Color ivory       = Color(0xFFFFF8F0); 
  static const Color whiteColor  = Colors.white;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final kb = mq.viewInsets.bottom;

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


          Positioned(
            top: -30,
            right: -20,
            child: _Bubble(color: primaryPink.withOpacity(.18), size: 140),
          ),
          Positioned(
            top: 90,
            left: -30,
            child: _Bubble(color: primaryPink.withOpacity(.12), size: 110),
          ),

  
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 24, 24, kb + 24),
              child: Center(
                child: Column(
                  children: [
   
                    Container(
                      width: 90,
                      height: 90,
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
                        border: Border.all(color: primaryPink.withOpacity(.35), width: 2),
                      ),
                      child: const Icon(Icons.person_add_alt_1_rounded, size: 44, color: primaryPink),
                    ),

                    const SizedBox(height: 14),
                    Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(.85),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Isi data di bawah untuk mulai belanja",
                      style: TextStyle(
                        color: Colors.black.withOpacity(.55),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),


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
                        backgroundBlendMode: BlendMode.softLight,
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            _Input(
                              controller: controller.usernameController,
                              label: 'Username',
                              hint: 'Username',
                              icon: Icons.person_rounded,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Username tidak boleh kosong"
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            _Input(
                              controller: controller.emailController,
                              label: 'Email',
                              hint: 'nama@email.com',
                              icon: Icons.email_rounded,
                              inputType: TextInputType.emailAddress,
                              validator: controller.validateEmail,
                            ),
                            const SizedBox(height: 14),
                            _Input(
                              controller: controller.passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              icon: Icons.lock_rounded,
                              obscure: true,
                              validator: controller.validatePassword,
                            ),
                            const SizedBox(height: 14),
                            _Input(
                              controller: controller.confirmPasswordController,
                              label: 'Konfirmasi Password',
                              hint: '••••••••',
                              icon: Icons.lock_person_rounded,
                              obscure: true,
                              validator: controller.validateConfirmPassword,
                            ),

                            const SizedBox(height: 10),

         
                            Obx(() {
                              return controller.isLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: CircularProgressIndicator(color: primaryPink),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: controller.doRegister,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryPink,
                                          foregroundColor: whiteColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 2.5,
                                          shadowColor: primaryPink.withOpacity(.35),
                                        ),
                                        child: const Text(
                                          "Daftar Sekarang",
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

        
                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: Colors.black.withOpacity(.08))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "atau",
                            style: TextStyle(color: Colors.black.withOpacity(.45), fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Container(height: 1, color: Colors.black.withOpacity(.08))),
                      ],
                    ),

                    const SizedBox(height: 14),

     
                    TextButton(
                      onPressed: () => Get.off(() => const LoginView()),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryPink,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text(
                        "Sudah punya akun? Masuk",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
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
    this.validator,
    this.obscure = false,
    this.inputType = TextInputType.text,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType inputType;

  static const Color primaryPink = _RegisterViewState.primaryPink;
  static const Color lightPinkBG = _RegisterViewState.lightPinkBG;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryPink),
        filled: true,
        fillColor: lightPinkBG,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
        hintStyle: TextStyle(color: Colors.black.withOpacity(.35)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryPink.withOpacity(.28), width: 1.2),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryPink, width: 1.6),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.6),
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
      width: size, height: size,
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
