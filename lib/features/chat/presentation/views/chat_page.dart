
import 'package:flutter/material.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/socket_service.dart';
import '../../data/repositories/chat_repository.dart';

class ChatPage extends StatefulWidget {
  final SocketService socketService;
  final String chatId;
  final String userId;
  const ChatPage({required this.socketService, required this.chatId, required this.userId, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  List<dynamic> messages = [];
  bool loading = true;
  late final ChatRepository repo;
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    repo = ChatRepository(ApiService());
    _loadMessages();
    widget.socketService.onReceive((data) {
      setState(() {
        messages.add(data);
        _scrollToBottom();

      });
    });

  }

  Future _loadMessages() async {
    try {
      final res = await repo.getMessages(widget.chatId);
      setState(() { messages = res; });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  Future _send() async {
    if(_ctrl.text.isNotEmpty){
      final body = {
        'chatId': widget.chatId,
        'senderId': widget.userId,
        'content': _ctrl.text.trim(),
        'messageType': 'text',
        'fileUrl': ''
      };
      try {
        await repo.sendMessage(body);
        widget.socketService.sendMessage(body);
        setState(() {
          messages.add({'content': _ctrl.text.trim(), 'senderId': widget.userId});
          _ctrl.clear();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat ${widget.chatId}')),
      body: Column(
        children: [
          Expanded(child:
            loading ? const Center(child: CircularProgressIndicator()) :
            ListView.builder(
              itemCount: messages.length,
              controller:_scrollController ,
              itemBuilder: (context, idx) {
                final m = messages[idx];
                final content = m['content'] ?? m['message'] ?? m.toString();
                final isMe = (m['senderId'] ?? '') == widget.userId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical:4, horizontal:8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: isMe ? Colors.blue[100] : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                    child: Text(content.toString()),
                  ),
                );
              },
            )
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Type a message'))),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
