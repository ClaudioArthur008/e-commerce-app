import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_app/src/core/routing/routes.dart';

/* 
Flutter Project — E-commerce app with Riverpod
Validate your state management skills by building a functional e-commerce app.

Instructions

max 100 pts
Build a Flutter e-commerce application using Riverpod as the state management solution.

Required features:

Product catalog (list + detail)
Shopping cart (add, remove, quantity)
Favorites system persisted locally
Product filtering and sorting
User profile screen (mock)
Technical requirements:

Use Riverpod exclusively (StateNotifierProvider, FutureProvider, etc.)
At least 5 distinct providers
Separate business logic from widgets (layered architecture)
Handle loading and error states in the UI
Use `AsyncValue` for async data
Product data can be mocked (local JSON or fake API)
Bonus (optional): animations on cart add.

Delivery: public GitHub repo with README detailing the architecture and providers used.
*/

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
    );
  }
}
