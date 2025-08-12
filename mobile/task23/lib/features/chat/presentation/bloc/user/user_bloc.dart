import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../domain/usecases/get_all_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  UserBloc({required this.getUsers}) : super(UserInitial()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading());
      final result = await getUsers();
      result.fold(
        (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
        (users) => emit(UsersLoaded(users: users)),
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
