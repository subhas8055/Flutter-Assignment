
import '../../../../core/network/api_service.dart';

class AuthRepository {
  final ApiService apiService;
  AuthRepository(this.apiService);

  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    return await apiService.post('user/login', {
      'email': email,
      'password': password,
      'role': role,
    });
  }
}
