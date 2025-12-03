import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final user = Rxn<User>();
  final isLoading = false.obs;

  final picker = ImagePicker();
  final userService = UserService();
  final authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;

    final email = await authService.currentEmail();
    if (email != null) {
      user.value = await userService.getUserByEmail(email);
    }

    isLoading.value = false;
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    String? password,
    List<String>? hobbies,
    String? imagePath,
    String? instagram,
    String? nim,
  }) async {
    if (user.value == null) return false;

    final u = user.value!;
    final updated = u.copyWith(
      username: username,
      email: email,
      password: password ?? u.password,
      hobbies: hobbies,
      photoPath: imagePath,
      instagram: instagram,
      nim: nim,
    );

    await userService.saveUser(updated);
    user.value = updated;
    user.refresh();

    return true;
  }

  /// ---------------- DELETE ACCOUNT ----------------
  Future<void> deleteAccount() async {
    final email = await authService.currentEmail();
    if (email == null) return;

    await userService.deleteUser(email);
    await authService.logout();

    Get.offAllNamed('/'); // arahkan ulang ke halaman awal
  }

  /// ---------------- IMAGE PICKER ----------------
  Future<String?> pickImageGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked?.path;
  }

  Future<String?> pickImageCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    return picked?.path;
  }

  void openEditProfileView() {
    Get.toNamed('/edit-profile');
  }
}
