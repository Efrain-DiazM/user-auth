import 'package:get/get.dart';
import 'package:users_auth/controllers/user_controller.dart';

import 'package:users_auth/data/repositories/auth_repository.dart';
import 'package:users_auth/presentation/pages/home_page.dart';
import 'package:users_auth/presentation/pages/login_page.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString currentUserId = ''.obs;

  AuthController(this._authRepository);

  Future<bool> checkAuth() async {
    isLoading.value = true;
    try {
      return await _authRepository.isLoggedIn();
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
  isLoading.value = true;
  error.value = '';
  currentUserId.value = '';

  try {
    await _authRepository.login(email: email, password: password);
    final user = await _authRepository.getCurrentUser();
    print('Usuario autenticado: ${user.$id}'); // Depuración
    currentUserId.value = user.$id;
    print('currentUserId establecido: ${currentUserId.value}'); // Depuración
    Get.offAll(() => HomePage());
    // Llamar a fetchUsers después de navegar
    final userController = Get.find<UserController>();
    await userController.fetchUsers();
  } catch (e) {
    error.value = e.toString();
    print('Error en login: $e'); // Depuración
  } finally {
    isLoading.value = false;
  }
}

  Future<void> register(String email, String password, String name) async {
    isLoading.value = true;
    error.value = '';

    try {
      await _authRepository.createAccount(
        email: email,
        password: password,
        name: name,
      );
      await login(email, password);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      Get.offAll(() => LoginPage());
    } catch (e) {
      error.value = e.toString();
    }
  }
}
