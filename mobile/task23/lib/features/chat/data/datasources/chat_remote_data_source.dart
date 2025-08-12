import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

const CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

abstract class ChatRemoteDataSource {
  /// Calls GET /chats
  Future<List<ChatModel>> getAllChats();

  /// Calls GET /chats/{chatId}/messages
  Future<List<MessageModel>> getChatMessages(String chatId);

  Future<ChatModel> initiateChat(String userId);
  Future<List<UserModel>> getAllUsers();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.client,
    this.baseUrl =
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3',
  });

  Future<Map<String, String>> get _headers async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(CACHED_AUTH_TOKEN);

    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.get(url, headers: await _headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> chatListJson = body['data'];
      print("loaded chat is  $chatListJson");
      final chats = chatListJson
          .map((json) => ChatModel.fromJson(json))
          .toList();
      return chats;
    } else {
      print("Here is the date ERROR");
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/chats/$chatId/messages');
    final response = await client.get(url, headers: await _headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> messageListJson = body['data'];
      print("here is the message $messageListJson");
      final messages = messageListJson
          .map((json) => MessageModel.fromJson(json))
          .toList();
      return messages;
    } else {
      print("here is the error ");
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.post(
      url,
      headers: await _headers,
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 201) {
      final body = json.decode(response.body);
      final chatJson = body['data'];
      return ChatModel.fromJson(chatJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users',
      ),
      headers: await _headers,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
