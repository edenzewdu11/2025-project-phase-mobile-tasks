import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/chat_remote_data_source.dart';
import 'data/datasources/chat_socket_data_source.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/usecases/get_all_chat.dart';
import 'domain/usecases/get_all_user.dart';
import 'domain/usecases/get_chat_message.dart';
import 'domain/usecases/initiate_chat.dart';
import 'domain/usecases/listen_for_delivered_messages.dart';
import 'domain/usecases/listen_incoming_message.dart';
import 'domain/usecases/send_message.dart';
import 'presentation/bloc/chat/chat_bloc.dart';
import 'presentation/bloc/user/user_bloc.dart';

final chatSl = GetIt.instance;

Future<void> initChat() async {
  //! Features - Chat

  // Bloc
  chatSl.registerFactory(
    () => ChatBloc(
      getAllChats: chatSl(),
      getChatMessages: chatSl(),
      initiateChat: chatSl(),
      sendMessage: chatSl(),
      listenForIncomingMessages: chatSl(),
      listenForDeliveredMessages: chatSl(),
    ),
  );
  // Register UserBloc
  chatSl.registerFactory<UserBloc>(() => UserBloc(getUsers: chatSl()));

  // Use cases
  chatSl.registerLazySingleton(() => GetAllChats(chatSl()));
  chatSl.registerLazySingleton(() => GetChatMessages(chatSl()));
  chatSl.registerLazySingleton(() => InitiateChatUseCase(chatSl()));
  chatSl.registerLazySingleton(() => SendMessage(chatSl()));
  chatSl.registerLazySingleton(() => ListenForIncomingMessages(chatSl()));
  chatSl.registerLazySingleton(() => ListenForDeliveredMessages(chatSl()));
  chatSl.registerLazySingleton(() => GetUsers(chatSl()));

  // Repository
  chatSl.registerLazySingleton<ChatRepository>(
    () =>
        ChatRepositoryImpl(remoteDataSource: chatSl(), socketService: chatSl()),
  );

  // Data sources
  chatSl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      client: chatSl(),
      // You can optionally pass baseUrl here or use default in implementation
    ),
  );

  // final sharedPreferences = await SharedPreferences.getInstance();

  chatSl.registerLazySingleton<ChatSocketDataSource>(
    () => ChatSocketDataSourceImpl(sharedPreferences: chatSl()),
  );

  // Core dependencies (http.Client, SharedPreferences) should be registered globally, if not, register here:
  // chatSl.registerLazySingleton(() => http.Client());
  // chatSl.registerLazySingleton(() => sharedPreferences);
}
