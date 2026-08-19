import 'package:flutter/material.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const ControleKmApp());
}

class ControleKmApp extends StatelessWidget {
  const ControleKmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'controle_km',
// Tema Dark (Padrão)
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      themeMode: ThemeMode.dark,

      routerConfig: appRouter,
    );
  }
}
