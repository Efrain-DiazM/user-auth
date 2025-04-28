import 'package:appwrite/appwrite.dart';
import 'package:users_auth/core/constants/appwrite_constants.dart';
import 'package:users_auth/model/user_model.dart';

class UserRepository {
  final Databases databases;

  UserRepository(this.databases);

  Future<UserModel> createUser(UserModel user, String userIdLogged) async {
    try {
      final data = {
        ...user.toJson(),
        'userId': userIdLogged,
      };
      print('Datos enviados a Appwrite: $data'); // Depuración
      final response = await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: ID.unique(),
        data: data,
      );

      print('Respuesta de Appwrite: ${response.data}'); // Depuración
      return UserModel.fromJson(response.data);
    } catch (e) {
      print('Error al crear usuario: $e'); // Depuración
      rethrow;
    }
  }

  Future<List<UserModel>> getUsers(String loggedInUserId) async {
    try {
      print('Filtrando usuarios con userId: $loggedInUserId');
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        queries: [
          Query.equal('userId', loggedInUserId), // Filtrar por userId
        ],
      );

      print('Documentos obtenidos de Appwrite: ${response.documents.map((doc) => doc.data).toList()}'); // Depuración
      return response.documents
          .map((doc) => UserModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser(String userId, UserModel user) async {
    try {
      final response = await databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: userId,
        data: user.toJson(),
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
