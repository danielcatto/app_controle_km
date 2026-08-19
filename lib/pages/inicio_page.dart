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
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(
                "assets/images/logo.jpg",
                fit: BoxFit.fill,
              ),
            ),
            const Text(
              'Bem-vindo ao Controle de KM',
              style: TextStyle(fontSize: 20),
              
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 244, 241, 54), // Cor do fundo do botão
              foregroundColor: const Color.fromARGB(255, 7, 4, 4), // Cor do texto e ícone
              minimumSize: const Size(20, 45), // Largura: 200px | Altura: 45px
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Bordas arredondadas (opcional)
              ),
            ),
              onPressed: () => context.go('/add'),
              child: const Text('Adicionar delocamentos'),
            ),
          ],
        ),
      ),
    );
  }
}
