import 'package:controle_km/controllers/calcular_consumo.dart';
import 'package:controle_km/data/database_helper.dart';
import 'package:flutter/material.dart';

class CalcularKmPage extends StatefulWidget {
  const CalcularKmPage({Key? key}) : super(key: key);

  @override
  State<CalcularKmPage> createState() => _CalcularKmPageState();
}

class _CalcularKmPageState extends State<CalcularKmPage> {
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  double? _resultado;

  Future<void> _calcular() async {
    final dist = double.tryParse(_distController.text.replaceAll(',', '.'));
    final litros = double.tryParse(_litrosController.text.replaceAll(',', '.'));

    if (dist == null || litros == null || litros == 0) {
      setState(() => _resultado = null);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira valores válidos')));
      return;
    }

    final calcular = CalcularConsumo();
    final res = calcular.calcularConsumo(dist, litros);
    setState(() => _resultado = res);

    // salvar no banco
    /*
    try {
      await DatabaseHelper.instance.insertCalculo({
        'distancia': dist,
        'litros': litros,
        'resultado': res,
        'createdAt': DateTime.now().toIso8601String(),
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cálculo salvo')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }*/
  }

  @override
  void dispose() {
    _distController.dispose();
    _litrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Calcular consumo (km/l)', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          TextField(
            controller: _distController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Distância (km)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _litrosController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Litros consumidos'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _calcular, child: const Text('Calcular')),
          const SizedBox(height: 20),
          if (_resultado != null)
            Center(
              child: Text(
                '${_resultado!.toStringAsFixed(2)}l \nPara você abastecer',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            
          if (_resultado == null)
            const Text('Preencha valores válidos para calcular.'),
        ],
      ),
    );
  }
}
