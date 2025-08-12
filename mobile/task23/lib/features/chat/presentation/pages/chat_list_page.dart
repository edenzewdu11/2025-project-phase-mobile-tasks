import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../injection_container.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/user/user_bloc.dart';
import 'chat_detail_page.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  static Widget withBloc({required String currentUserId}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => chatSl<ChatBloc>()..add(LoadChatsEvent())),
        BlocProvider(create: (_) => chatSl<UserBloc>()..add(LoadUsersEvent())),
      ],
      child: ChatListScreen(currentUserId: currentUserId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3081F2),
      body: SafeArea(
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatInitiated) {
              final otherUser = state.chat.user1.id == currentUserId
                  ? state.chat.user2
                  : state.chat.user1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen.withBloc(
                    chatId: state.chat.id,
                    currentUserId: currentUserId,
                    otherUserId: otherUser.id,
                    otherUserName: otherUser.name,
                  ),
                ),
              );
            } else if (state is ChatError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Column(
            children: [
              // Gradient Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3081F2), Color(0xFF56B4F2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Chats",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white70),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Top Row - List of Users
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (state is UsersLoaded) {
                          final sortedUsers = List<User>.from(state.users)
                            ..sort((a, b) => a.name.compareTo(b.name));
                          return StatusAvatars(
                            users: sortedUsers,
                            currentUserId: currentUserId,
                          );
                        } else if (state is UserError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              // Chat List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatsLoaded) {
                        return ChatList(
                          chats: state.chats,
                          currentUserId: currentUserId,
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusAvatars extends StatelessWidget {
  final List<User> users;
  final String currentUserId;

  const StatusAvatars({
    super.key,
    required this.users,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherUsers = users.where((u) => u.id != currentUserId).toList();

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: otherUsers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final user = otherUsers[index];
          return InkWell(
            onTap: () {
              context.read<ChatBloc>().add(InitiateChatEvent(userId: user.id));
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: const AssetImage('images/profile.png'),
                      backgroundColor: Colors.grey[200],
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<Chat> chats;
  final String currentUserId;

  const ChatList({super.key, required this.chats, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final otherUser = chat.user1.id == currentUserId
            ? chat.user2
            : chat.user1;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen.withBloc(
                  chatId: chat.id,
                  currentUserId: currentUserId,
                  otherUserId: otherUser.id,
                  otherUserName: otherUser.name,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: const AssetImage('images/profile.png'),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUser.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Last message preview...",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    "12:30 PM",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "2",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
