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
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
