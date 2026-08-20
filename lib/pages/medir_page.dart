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

    // Configurações do GPS (alta precisão e atualização a cada 5 metros percorridos)
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Atualiza apenas se o usuário andar mais de 5 metros
    );

    // Começa a escutar as atualizações de localização em tempo real
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        if (_ultimaPosicao != null) {
          // Calcula a distância entre o ponto anterior e o atual
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
    _positionStream?.cancel(); // Para o consumo do GPS
    _positionStream = null;

    setState(() {
      _emAndamento = false;
    });

    double totalKm = _distanciaTotalMetros / 1000;
    try {
      DatabaseHelper.instance.inserirDeslocamento(totalKm);

      if (!mounted) return;
    } catch (e) {}
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rota Finalizada!'),
        content: Text(
          'Você percorreu: ${totalKm.toStringAsFixed(2)} km\n'
          '(${_distanciaTotalMetros.toStringAsFixed(0)} metros)',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Garante o cancelamento ao fechar a tela
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
