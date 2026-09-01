# Supabase Demo Flutter App

A Flutter application demonstrating **Supabase Authentication**, **Database Operations (CRUD)**, and **Realtime Chat with PostgreSQL Channels**.

---

## Tech Stack & Requirements

- **Flutter SDK**: `3.38.7` (Dart `3.10.7`) managed via [FVM (Flutter Version Management)](https://fvm.app/)
- **Android Gradle Plugin (AGP)**: `8.11.1`
- **Gradle**: `8.14`
- **Kotlin**: `2.2.20`
- **Java**: `17`
- **Backend / Database**: [Supabase](https://supabase.com/) (Auth, PostgreSQL, Realtime)

---

## Features

- **Authentication**: Email/Password authentication & Google OAuth sign-in via Supabase Auth.
- **Employee Management**: Create, read, and manage employee records.
- **Attendance Tracking**: Track check-in and check-out attendance for each employee with date-sorted logs.
- **Realtime Chat**: 1-to-1 realtime messaging with Supabase PostgreSQL channel subscriptions.
- **Navigation**: Declarative routing with GoRouter.
- **State Management**: Riverpod for reactive state.

---

## Getting Started

### 1. Flutter Version Management (FVM) Setup

Ensure FVM is installed, then configure the project:

```bash
# Install and use Flutter 3.38.7
fvm use 3.38.7

# Install project dependencies
fvm flutter pub get
```

### 2. Supabase Project Setup

1. Create a project at [Supabase](https://supabase.com/).
2. Open the **SQL Editor** in your Supabase Dashboard and run the following schema to create tables and configure Row-Level Security (RLS):

```sql
-- 1. Users table
CREATE TABLE IF NOT EXISTS public.users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    profile_pic TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Employees table
CREATE TABLE IF NOT EXISTS public.employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Attendance table
CREATE TABLE IF NOT EXISTS public.attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID REFERENCES public.employees(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Chat Rooms table
CREATE TABLE IF NOT EXISTS public.chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user1 TEXT NOT NULL,
    user2 TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Chat Messages table
CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_room_id UUID REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
    sender_id TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS and add access policies
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all users access" ON public.users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all employees access" ON public.employees FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all attendance access" ON public.attendance FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all chat_rooms access" ON public.chat_rooms FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all chat_messages access" ON public.chat_messages FOR ALL USING (true) WITH CHECK (true);
```

### 3. Configure Supabase Credentials

Update your Supabase URL and Publishable/Anon Key in [`lib/main.dart`](lib/main.dart):

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_PROJECT_URL',       // e.g. https://xyzcompany.supabase.co
    publishableKey: 'YOUR_SUPABASE_KEY',    // e.g. sb_publishable_... or anon key
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

## Dependencies

Key dependencies configured in [`pubspec.yaml`](pubspec.yaml):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.9
  supabase_flutter: ^2.17.2
  intl: ^0.20.3
  go_router: ^17.5.0
  flutter_secure_storage: ^11.0.0
  flutter_riverpod: ^2.6.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

## Running the App

```bash
# Run on connected device / emulator
fvm flutter run

# Run static analysis
fvm flutter analyze

# Run tests
fvm flutter test
```

---

## Demo Video

https://github.com/user-attachments/assets/139fe8e7-c4dc-4bea-ac6c-ffd186461cab
