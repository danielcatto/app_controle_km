import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bem-vindo ao Controle de KM',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/calcular'),
              child: const Text('Ir para Calcular KM'),
            ),
          ],
        ),
      ),
    );
  }
}
