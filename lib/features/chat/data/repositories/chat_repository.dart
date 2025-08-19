
import '../../../../core/network/api_service.dart';

class ChatRepository {
  final ApiService apiService;
  ChatRepository(this.apiService);

  Future<List<dynamic>> getUserChats(String userId) async {
    final res = await apiService.get('chats/user-chats/$userId');
    // API might return list directly; adjust based on real response.
    if (res.isNotEmpty) return res as List<dynamic>;
    return res as List<dynamic>;
  }

  Future<List<dynamic>> getMessages(String chatId) async {
    final res = await apiService.get('messages/get-messagesformobile/$chatId');
    if (res.isNotEmpty) return res as List<dynamic>;
    return res as List<dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async {
    return await apiService.post('messages/sendMessage', body);
  }
}
