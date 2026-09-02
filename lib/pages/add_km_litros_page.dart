import 'package:flutter/material.dart';
import 'package:controle_km/data/database_helper.dart';

//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _kmController = TextEditingController();

  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _kmController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvarKm() async {
    final texto = _kmController.text.replaceAll(',', '.');
    final km = double.tryParse(texto);
    final descricao = _descricaoController.text.trim();

    if (km == null || km <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe um valor de Km válido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await DatabaseHelper.instance.inserirDeslocamento(descricao, km);

      if (!mounted) return;

      _kmController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deslocamento de $km Km salvo com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.drive_eta,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Adicionar deslocamento',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _descricaoController,
                  //keyboardType:
                  //const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _kmController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Km rodado',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 40),
                ),
                onPressed: _salvarKm,
                child: const Text('Add'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
