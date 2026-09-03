import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  // Estado que armazena a seleção atual
  String _tipoCombustivel = 'Etanol'; // Valor padrão

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(248, 115, 106, 231),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Configurações do aplicativo',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo Dropdown Inserido
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: _tipoCombustivel,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de combustível padrão',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Gasolina',
                      child: Text('Gasolina'),
                    ),
                    DropdownMenuItem(
                      value: 'Etanol',
                      child: Text('Etanol'),
                    ),
                    DropdownMenuItem(
                      value: 'Diesel',
                      child: Text('Diesel'),
                    ),
                  ],
                  onChanged: (novoValor) {
                    if (novoValor != null) {
                      setState(() {
                        _tipoCombustivel = novoValor;
                      });
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}