
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_service.dart';
import 'core/network/socket_service.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/views/login_page.dart';
import 'features/chat/data/repositories/chat_repository.dart';

void main() {

  final apiService = ApiService();
  final socketService = SocketService();
  runApp(MyApp(apiService: apiService, socketService: socketService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final SocketService socketService;
  const MyApp({required this.apiService, required this.socketService, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(apiService)),
        RepositoryProvider(create: (_) => ChatRepository(apiService)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: LoginPage(socketService: socketService),
        ),
      ),
    );
  }
}
