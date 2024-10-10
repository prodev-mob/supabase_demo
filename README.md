# supabase_demo

This Flutter application demonstrates SupaBase Authentication & DataBase.

## Getting Started

This project is a starting point for a Flutter application.

## Features
- Employee authentication using email/password.
- Create & Read Empolyee attendance data like Date, Check-In Time , Check-Out Time.
- Implement chat using real time Databaese.

## Getting Started

1) Check official SupaBase Documents for configure SupaBase in your Project.
https://supabase.com/docs/guides/getting-started/quickstarts/flutter


2) Dependencies

    Add below dependencies in pubspec.yaml
```
dependencies:
  supabase_flutter: ^2.0.0
```

4) Code Setup

- initialize SupaBase Client in your main.dart
```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'ADD_YOUR_URL',
    anonKey: 'ADD-YOUR-ANON-KEY',
  );
  runApp(MyApp());
}
```

- Register user using email/password
```
final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
```

- Login user using email/password
```
final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
```

- Sign Out
```
  await Supabase.instance.client.auth.signOut();
```

- add users after Signup in users Tabel
```
  
        await supabase.from('users').insert({
          'id': userId,
          'name': name,
          'email': email,
          'profile_pic': image,
        });

```
- Fetch chat user's list.
```
 
    final response = await supabase.from('users').select('id, name, profile_pic').not('id', 'eq', loggedInUserId);
```

- If chat room is exist  then it open Direct chat room otherwise it's create new chat room.
```
Future<void> _startChat(String otherUserId) async {
    // Check if chat room already exists

    final response = await supabase
        .from('chat_rooms')
        .select('id')
        .or('and(user1.eq.$loggedInUserId,user2.eq.$otherUserId),and(user1.eq.$otherUserId,user2.eq.$loggedInUserId)');


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

      if ((response.first["id"] ?? "").toString().isNotEmpty) {
        // Navigate to the chat room screen
        context.go(
          RouteNameConstant.chatRoom.replaceFirst(":chatRoomAndUserId", "${response.first["id"]}--$otherUserId"),
        );
      }
    } else {
      if ((response.first["id"] ?? "").toString().isNotEmpty) {
        // Navigate to the chat room screen
        context.go(
          RouteNameConstant.chatRoom.replaceFirst(":chatRoomAndUserId", "${response.first["id"]}--$otherUserId"),
        );
      }
    }
  }
```
- Listen all new Messages
```
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

            
              setState(() {
                messages.add(payload.newRecord);
              });
            })
        .subscribe();
  }
```


## Videos

https://github.com/user-attachments/assets/139fe8e7-c4dc-4bea-ac6c-ffd186461cab


