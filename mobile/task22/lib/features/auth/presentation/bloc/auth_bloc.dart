import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_logged_in_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final Logout logout;
  final GetLoggedInUser getLoggedInUser;

  AuthBloc({
    required this.login,
    required this.register,
    required this.logout,
    required this.getLoggedInUser,
  }) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await login(email: event.email, password: event.password);

      result.fold(
        (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
        (_) => add(GetUserEvent()), // chain to get the user after login
      );
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      result.fold(
        (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
        (user) => emit(AuthAuthenticated(user: user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await logout();

      result.fold(
        (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
        (_) => emit(AuthUnauthenticated()),
      );
    });

    on<GetUserEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await getLoggedInUser();

      result.fold(
        (failure) => emit(AuthUnauthenticated()), // fallback to unauth
        (user) => emit(AuthAuthenticated(user: user)),
      );
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure _:
      return 'Server Failure';
    case CacheFailure _:
      return 'Cache Failure';
    case NetworkFailure _:
      return 'No Internet Connection';
    default:
      return 'Unexpected error';
  }
}
