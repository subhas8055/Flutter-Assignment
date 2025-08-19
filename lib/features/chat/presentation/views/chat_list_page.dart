
import 'package:flutter/material.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/socket_service.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  final SocketService socketService;
  final String userId;
  const ChatListPage({required this.socketService, required this.userId, super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late final ChatRepository repo;
  List<dynamic> chats = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    repo = ChatRepository(ApiService());
    _load();
  }

  Future _load() async {
    try {
      final res = await repo.getUserChats(widget.userId);
      setState(() { chats = res; });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat App')),
      body: loading ? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, idx) {
          final c = chats[idx];
          final chatId = c['_id'] ?? c['chatId'] ?? '';
          final title = c['name'] ?? c['title'] ?? 'Chat $idx';
          return Container(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: Text(title.toString()),
              subtitle: Text(chatId.toString()),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(socketService: widget.socketService, chatId: chatId.toString(), userId: widget.userId)));
              },
            ),
          );
        },
      ),
    );
  }
}
