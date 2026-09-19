import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_km/data/database_helper.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  String _tipoCombustivel = 'Etanol'; // Valor padrão inicial

  @override
  void initState() {
    super.initState();
    _carregarCombustivelSalvo();
  }

  // Carrega o valor salvo no armazenamento interno
  Future<void> _carregarCombustivelSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final tipoCombustivel = prefs.getString('tipo_combustivel') ?? 'Etanol';
    await DatabaseHelper.instance.salvarCombustivelNoBanco(tipoCombustivel);

    if (!mounted) return;

    setState(() {
      _tipoCombustivel = tipoCombustivel;
    });
  }

  // Salva o novo valor no armazenamento interno
  Future<void> _salvarCombustivel(String novoValor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tipo_combustivel', novoValor);
    await DatabaseHelper.instance.salvarCombustivelNoBanco(novoValor);
  }

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
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  initialValue: _tipoCombustivel,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de combustível',
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
                      // Salva a alteração no banco/preferências
                      _salvarCombustivel(novoValor);
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
