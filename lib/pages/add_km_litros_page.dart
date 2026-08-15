import 'package:flutter/material.dart';


class Addpage extends StatelessWidget {
  const Addpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Sobre o app',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),
                    
          Padding(
            // Aplica 16 pixels de margem/espaçamento em todos os lados
            padding: const EdgeInsets.all(20.0), 
            child: const Text(
              'Esta aplicação foi desenvolvida para realizar os cálculos de rodagem de chamados dos técnicos de campo, seguindo as regras de negócio da Diebold Nixdorf.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )

        ],
      ),
    );
  }
}
