import 'package:controle_km/controllers/calcular_consumo.dart';
import 'package:flutter/material.dart';
import 'package:controle_km/data/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalcularKmPage extends StatefulWidget {
  const CalcularKmPage({Key? key}) : super(key: key);

  @override
  State<CalcularKmPage> createState() => _CalcularKmPageState();
}

class _CalcularKmPageState extends State<CalcularKmPage> {
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();

  double? _resultado;
  double? _km_total;

  List<Map<String, dynamic>> _deslocamentos = [];

  @override
  void initState() {
    super.initState();
    _carregarDeslocamentos();
    _carregarUltimoLitros();
  }

  Future<void> _carregarUltimoLitros() async {
    final prefs = await SharedPreferences.getInstance();
    final ultimoLitros = prefs.getString('ultimo_litros');

    if (ultimoLitros != null && mounted) {
      setState(() {
        _litrosController.text = ultimoLitros;
      });
    }
  }

  Future<void> _salvarUltimoLitros(String valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimo_litros', valor);
  }

  Future<void> _carregarDeslocamentos() async {
    final dados = await DatabaseHelper.instance.listarDeslocamentos();

    double total = 0.0;

    for (final deslocamento in dados) {
      total += (deslocamento['km'] as num).toDouble();
    }
    _km_total = total;
    if (!mounted) return;

    setState(() {
      _deslocamentos = dados;
    });
  }

  Future<void> _calcular() async {
    final textoLitros = _litrosController.text.replaceAll(',', '.');
    final litros = double.tryParse(textoLitros);

    if (litros == null || litros <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insira valores válidos'),
        ),
      );
      return;
    }

    await _salvarUltimoLitros(_litrosController.text);

    final calcular = CalcularConsumo();

    final resultado = calcular.calcularConsumo(
      _km_total ?? 0.0,
      litros,
    );

    setState(() {
      _resultado = resultado;
    });
  }

  Future<void> _deletarTudo() async {
    await DatabaseHelper.instance.deletarTodosDeslocamentos();

    if (!mounted) return;

    setState(() {
      _deslocamentos = [];
      _km_total = 0.0;
      _resultado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todos os deslocamentos foram deletados!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Modal para confirmar a exclusão completa de dados
  Future<void> _confirmarDeletarTudo() async {
    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar todo o histórico'),
        content: const Text(
          'Deseja realmente apagar TODOS os deslocamentos cadastrados? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Apagar Tudo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _deletarTudo();
    }
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
          const Text(
            'Calcular consumo (km/l)',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
            child: TextField(
              controller: _litrosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (valor) => _salvarUltimoLitros(valor),
              decoration: const InputDecoration(
                labelText: 'Litros consumidos',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Km total: ${(double.tryParse(_km_total.toString()) ?? 0.0).toStringAsFixed(3).replaceAll('.', ',')} KM',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(153, 121, 119, 119),
              foregroundColor: const Color.fromARGB(255, 253, 252, 252),
              minimumSize: const Size(20, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _calcular,
            child: const Text('Calcular'),
          ),
          const SizedBox(height: 8),

          // --- BOTÃO ADICIONADO PARA DELETAR TUDO ---
          if (_deslocamentos.isNotEmpty)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size(20, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _confirmarDeletarTudo,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Limpar Todos os Deslocamentos'),
            ),

          const SizedBox(height: 20),
          if (_resultado != null)
            Center(
              child: Text(
                '${_resultado!.toStringAsFixed(2)} Litros\n'
                'Para você abastecer',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          if (_resultado == null)
            const Text(
              'Preencha valores válidos para calcular.',
            ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: _deslocamentos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum deslocamento cadastrado.',
                    ),
                  )
                : ListView.builder(
                    itemCount: _deslocamentos.length,
                    itemBuilder: (context, index) {
                      final deslocamento = _deslocamentos[index];
                      final double kmValor =
                          (deslocamento['km'] as num).toDouble();

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.drive_eta,
                            color: Colors.blue,
                          ),
                          title: Text(
                            '${deslocamento['descricao'] ?? 'Sem descrição'}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${kmValor.toStringAsFixed(2)} km'),
                              Text(deslocamento['data']),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              bool? confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Excluir registro'),
                                  content: const Text(
                                      'Deseja realmente apagar este deslocamento?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Excluir',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar == true) {
                                await DatabaseHelper.instance
                                    .excluirDeslocamento(deslocamento['id']);
                                setState(() {
                                  _carregarDeslocamentos();
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
