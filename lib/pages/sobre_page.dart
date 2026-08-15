import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Calcular Litros de Combustiveis',
              style: TextStyle(fontSize: 30, color: Color.fromARGB(248, 23, 13, 170))),
          SizedBox(height: 20),
          Text(
            'Esta aplicação foi desenvolvida para realizar os cálculos de rodagem de chamados dos técnicos de campo, seguindo as regras de negócio da Diebold Nixdorf.',
            style: TextStyle(fontSize: 20, color: Color.from(alpha: 0.747, red: 0, green: 0, blue: 0)),
            
          )
        ],
      ),
    );
  }
}
