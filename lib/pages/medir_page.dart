import 'dart:async';
import 'package:controle_km/data/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RotaGpsPage extends StatefulWidget {
  const RotaGpsPage({Key? key}) : super(key: key);

  @override
  State<RotaGpsPage> createState() => _RotaGpsPageState();
}

class _RotaGpsPageState extends State<RotaGpsPage> {
  StreamSubscription<Position>? _positionStream;
  Position? _ultimaPosicao;

  // Controller para permitir ao usuário alterar a descrição da rota
  final TextEditingController _descricaoController =
      TextEditingController(text: 'Rota GPS');

  double _distanciaTotalMetros = 0.0;
  bool _emAndamento = false;

  // Função para verificar permissões de GPS antes de iniciar
  Future<bool> _verificarPermissao() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ative o GPS do aparelho.')),
        );
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Permissão de localização negada permanentemente.')),
        );
      }
      return false;
    }

    return true;
  }

  // INICIAR A MEDIÇÃO
  void _iniciarMedicao() async {
    bool temPermissao = await _verificarPermissao();
    if (!temPermissao) return;

    setState(() {
      _distanciaTotalMetros = 0.0;
      _ultimaPosicao = null;
      _emAndamento = true;
    });

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Atualiza a cada 5 metros percorridos
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        if (_ultimaPosicao != null) {
          double distanciaEntrePontos = Geolocator.distanceBetween(
            _ultimaPosicao!.latitude,
            _ultimaPosicao!.longitude,
            position.latitude,
            position.longitude,
          );

          setState(() {
            _distanciaTotalMetros += distanciaEntrePontos;
          });
        }

        _ultimaPosicao = position;
      },
    );
  }

  // FINALIZAR A MEDIÇÃO
  void _finalizarMedicao() {
    _positionStream?.cancel();
    _positionStream = null;

    setState(() {
      _emAndamento = false;
    });

    double totalKm = _distanciaTotalMetros / 1000;
    _descricaoController.text = 'Rota GPS'; // Valor padrão inicial

    // Exibe o Dialog permitindo informar a descrição antes de salvar
    showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar clicando fora
      builder: (context) => AlertDialog(
        title: const Text('Rota Finalizada!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distância: ${totalKm.toStringAsFixed(2)} km '
              '(${_distanciaTotalMetros.toStringAsFixed(0)} m)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Chamado / Cliente',
                hintText: 'Ex: Atendimento Agência X',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Descartar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final desc = _descricaoController.text.trim().isEmpty
                  ? 'Rota GPS'
                  : _descricaoController.text.trim();

              // Salva de forma assíncrona com await
              await DatabaseHelper.instance.inserirDeslocamento(desc, totalKm);

              if (!mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rota gravada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalKm = _distanciaTotalMetros / 1000;

    return Scaffold(
      appBar: AppBar(title: const Text('Medidor de Rota GPS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _emAndamento ? Icons.navigation : Icons.location_off,
              size: 80,
              color: _emAndamento ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'Distância Atual:',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            Text(
              '${totalKm.toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            if (!_emAndamento)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: _iniciarMedicao,
                icon: const Icon(Icons.play_arrow),
                label: const Text('INICIAR ROTA'),
              )
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: _finalizarMedicao,
                icon: const Icon(Icons.stop),
                label: const Text('FINALIZAR ROTA'),
              ),
          ],
        ),
      ),
    );
  }
}