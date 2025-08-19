
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await authRepository.login(event.email, event.password, event.role);
        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
