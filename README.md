# supabase_demo

This Flutter application demonstrates SupaBase Authentication & DataBase.

## Getting Started

This project is a starting point for a Flutter application.

## Features
- Employee authentication using email/password.
- Create & Read Empolyee attendance data like Date, Check-In Time , Check-Out Time.

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

## Videos

https://github.com/user-attachments/assets/139fe8e7-c4dc-4bea-ac6c-ffd186461cab


