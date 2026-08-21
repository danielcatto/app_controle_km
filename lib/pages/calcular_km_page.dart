import 'package:controle_km/controllers/calcular_consumo.dart';
import 'package:flutter/material.dart';
import 'package:controle_km/data/database_helper.dart';

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
  }

  //CARREGA DADOS PARA A DADOS
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
      _km_total;
    });
  }

  //BOTÃO CALCULAR
  Future<void> _calcular() async {
    final litros = double.tryParse(
      _litrosController.text.replaceAll(',', '.'),
    );

    if (litros == null || litros <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insira valores válidos'),
        ),
      );

      return;
    }

    final calcular = CalcularConsumo();

    final resultado = calcular.calcularConsumo(
      _km_total!,
      litros,
    );

    setState(() {
      _resultado = resultado;
    });
  }
  //FINAL DOS CALCULOS DA FUNÇÃO CALULAR()

  //Deletar tudo

  //BOTÃO CALCULAR
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
//final de deletar tudo

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

          TextField(
            controller: _litrosController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Litros consumidos',
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Km total: ${(double.tryParse(_km_total.toString()) ?? 0.0).toStringAsFixed(3).replaceAll('.', ',')} KM',
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  153, 121, 119, 119), // Cor do fundo do botão
              foregroundColor: const Color.fromARGB(
                  255, 253, 252, 252), // Cor do texto e ícone
              minimumSize: const Size(20, 45), // Largura: 200px | Altura: 45px
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Bordas arredondadas (opcional)
              ),
            ),
            onPressed: _calcular,
            child: const Text('Calcular'),
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

          //BOTÃO DELETE
/*   
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Cor do fundo do botão
              foregroundColor: Colors.white, // Cor do texto e ícone
              minimumSize: const Size(20, 45), // Largura: 200px | Altura: 45px
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Bordas arredondadas (opcional)
              ),
            ),
            onPressed: _deletarTudo,
            child: const Text('Deletar Tudo'),
          ),
  
*/
          // ######################################
          // Mostrar os km adicionados
          // ######################################

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

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.drive_eta,
                            color: Colors.blue,
                          ),
                          title: Text(
                            '${(double.tryParse(deslocamento['km'].toString()) ?? 0.0).toStringAsFixed(3).replaceAll('.', ',')} KM',
                          ),
                          subtitle: Text(
                            deslocamento['data'],
                          ),
                          // BOTÃO DE DELETAR A LINHA
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              // Exemplo com confirmação antes de deletar
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
                                // 1. Apaga do banco pelo ID
                                await DatabaseHelper.instance
                                    .excluirDeslocamento(deslocamento['id']);

                                // 2. Atualiza a tela (chame a sua função de recarregar a lista)
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
