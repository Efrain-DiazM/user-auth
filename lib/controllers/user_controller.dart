import 'package:get/get.dart';
import 'package:users_auth/controllers/auth_controller.dart';

import 'package:users_auth/model/user_model.dart';
import 'package:users_auth/data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository repository;

  UserController({required this.repository});

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchUsers();
    print('UserController onInit ejecutado');
  }

  Future<void> fetchUsers() async {
    try {
      print('Iniciando fetchUsers'); // Depuración
      isLoading.value = true;
      final loggedInUserId = Get.find<AuthController>().currentUserId.value;
      print('loggedInUserId en fetchUsers: $loggedInUserId'); // Depuración
      if (loggedInUserId.isEmpty) {
        throw Exception('No authenticated user found');
      }
      print(
          'Llamando a getUsers con loggedInUserId: $loggedInUserId'); // Depuración
      final fetchedUsers = await repository.getUsers(loggedInUserId);
      print('Usuarios obtenidos: $fetchedUsers'); // Depuración
      users.assignAll(fetchedUsers);
    } catch (e) {
      error.value = e.toString();
      print('Error al obtener usuarios: $e'); // Depuración
      users.clear();
    } finally {
      isLoading.value = false;
      print('fetchUsers finalizado'); // Depuración
    }
  }

  Future<void> addUser(UserModel user, String loggedInUserId) async {
    try {
      final newUser = await repository.createUser(user, loggedInUserId);
      users.add(newUser);
      await fetchUsers();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await repository.deleteUser(userId);
      users.removeWhere((user) => user.id == userId);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> updateUser(String userId, UserModel updatedUser) async {
    try {
      final user = await repository.updateUser(userId, updatedUser);
      final index = users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        users[index] = user;
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
}
