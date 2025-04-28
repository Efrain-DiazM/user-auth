import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AuthRepository {
  final Account account;

  AuthRepository(this.account);

  Future<void> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Nuevo método para obtener el usuario actual
  Future<models.User> getCurrentUser() async {
    try {
      final user = await account.get();
      print('Usuario obtenido de Appwrite: ${user.$id}'); // Depuración
      return user;
    } catch (e) {
      print('Error al obtener usuario autenticado: $e'); // Depuración
      rethrow;
    }
  }
}
