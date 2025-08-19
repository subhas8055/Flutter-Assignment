
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../chat/presentation/views/chat_list_page.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/network/socket_service.dart';

class LoginPage extends StatefulWidget {
  final SocketService socketService;
  const LoginPage({required this.socketService, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'vendor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'vendor'),
            ),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<AuthBloc>();
                bloc.add(LoginRequested(_emailCtrl.text.trim(), _passCtrl.text.trim(), _role));
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  // connect socket and navigate
                  final user = state.userData;
                  final userId = user['data']['user']?['_id']?.toString() ?? '';
                  widget.socketService.connect(userId);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatListPage(socketService: widget.socketService, userId: userId)));
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) return const CircularProgressIndicator();
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 10),
            const Text('Use credentials from the API description for testing')
          ],
        ),
      ),
    );
  }
}
