import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> users = [];
  String loggedInUserId = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchLoggedInUser();
      await _fetchUsers();
    });
    super.initState();
  }

  Future<void> _fetchLoggedInUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUserId = user.id;
      });
    }
  }

  Future<void> _fetchUsers() async {
    final response = await supabase.from('users').select('id, name, profile_pic').not('id', 'eq', loggedInUserId);

    if (response.isNotEmpty) {
      print("All Users :: $response");

      setState(() {
        users = List<Map<String, dynamic>>.from(response);
      });
    } else {
      print('Error fetching users:');
    }
  }

  Future<void> _startChat(String otherUserId) async {
    // Check if chat room already exists

    final response = await supabase
        .from('chat_rooms')
        .select('id')
        .or('and(user1.eq.$loggedInUserId,user2.eq.$otherUserId),and(user1.eq.$otherUserId,user2.eq.$loggedInUserId)');

    print("chat_rooms :: :: :: :: : $response");

    if (response.isEmpty) {
      // No chat room exists, create one
      await supabase.from('chat_rooms').insert({
        'user1': loggedInUserId,
        'user2': otherUserId,
        'created_at': DateTime.now().toIso8601String(),
      });

      final response = await supabase
          .from('chat_rooms')
          .select('id')
          .or('and(user1.eq.$loggedInUserId,user2.eq.$otherUserId),and(user1.eq.$otherUserId,user2.eq.$loggedInUserId)');

      print("chat_rooms :: :: :: :: : $response");

      if ((response.first["id"] ?? "").toString().isNotEmpty) {
        // Navigate to the chat room screen
        _navigateToChatRoom(otherUserId, response.first["id"] ?? "");
      }
    } else {
      if ((response.first["id"] ?? "").toString().isNotEmpty) {
        // Navigate to the chat room screen
        _navigateToChatRoom(otherUserId, response.first["id"] ?? "");
      }
    }
  }

  void _navigateToChatRoom(String otherUserId, String chatRoomId) {
    context.go(
      RouteNameConstant.chatRoom.replaceFirst(":chatRoomAndUserId", "$chatRoomId--$otherUserId"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['profile_pic']),
            ),
            title: Text(user['name']),
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () async {
                await _startChat(user['id']);
              },
            ),
          );
        },
      ),
    );
  }
}
