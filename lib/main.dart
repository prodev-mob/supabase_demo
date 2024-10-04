import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_demo/navigation/route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'ADD_YOUR_URL',
    anonKey:
        'ADD-YOUR-ANON-KEY',
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp.router(
          routerConfig: ref.read(Routes.rootRouter),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            dividerColor: const Color(0xffC0C0C0),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: _NoAnimationTransition(),
              TargetPlatform.iOS: _NoAnimationTransition(),
              // if you have more you can add them here
            }),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff141414),
              primary: const Color(0xff0076FA),
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}

class _NoAnimationTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(_, __, ___, ____, Widget child) => child;
}
