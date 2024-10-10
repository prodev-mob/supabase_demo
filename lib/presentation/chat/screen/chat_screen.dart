import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUserId;

  const ChatScreen({super.key, required this.chatRoomId, required this.otherUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String loggedInUserId = '';
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchLoggedInUser();
      _fetchMessages();
      _subscribeToRealTimeMessages();
    });
  }

  Future<void> _fetchLoggedInUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUserId = user.id;
      });
    }
  }

  Future<void> _fetchMessages() async {
    final response = await supabase
        .from('chat_messages')
        .select('sender_id, content, created_at')
        .eq('chat_room_id', widget.chatRoomId)
        .order('created_at', ascending: true);

    if (response.isNotEmpty) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(response);
      });

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      print('Error fetching messages:');
    }
  }

  void _subscribeToRealTimeMessages() {
    supabase
        .channel('chat_messages')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'chat_messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'chat_room_id',
              value: widget.chatRoomId,
            ),
            callback: (PostgresChangePayload payload) {
              final Map<String, dynamic> newRecord = payload.newRecord;

              debugPrint("newRecord :: :: :: :: : : $newRecord");

              setState(() {
                messages.add(payload.newRecord);
              });

              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            })
        .subscribe();
  }

  Future<void> _sendMessage(String content) async {
    if (content.isEmpty) return;

    await supabase.from('chat_messages').insert({
      'chat_room_id': widget.chatRoomId,
      'sender_id': loggedInUserId,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.otherUserId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender_id'] == loggedInUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['content']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
