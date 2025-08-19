
part of 'auth_bloc.dart';
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  LoginRequested(this.email, this.password, this.role);
}
