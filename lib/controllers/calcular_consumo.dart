/*
Classe para calcular o consumo em litros para controle
de abastecimento
*/

import 'package:controle_km/data/database_helper.dart';

class CalcularConsumo {
  Future<double> calcularConsumo(
    double distancia,
    double litrosAbastecidos,
  ) async {
    final tipoCombustivel = await _obterCombustivel();

    if (litrosAbastecidos < 1) {
      litrosAbastecidos = 1;
    }

    double consumoLonga;
    double consumoMedia;
    double consumoCurta;

    switch (tipoCombustivel) {
      case 'Gasolina':
        consumoLonga = 10.0;
        consumoMedia = 9.0;
        consumoCurta = 8.0;
        break;
      case 'Diesel':
        consumoLonga = 13.0;
        consumoMedia = 12.0;
        consumoCurta = 11.0;
        break;
      case 'Etanol':
      default:
        consumoLonga = 7.0;
        consumoMedia = 6.0;
        consumoCurta = 5.0;
        break;
    }

    double litrosNecessarios;
    if (distancia >= 500) {
      litrosNecessarios = distancia / consumoLonga;
    } else if (distancia < 500 && distancia >= 225) {
      litrosNecessarios = distancia / consumoMedia;
    } else {
      litrosNecessarios = distancia / consumoCurta;
    }

    return litrosNecessarios - litrosAbastecidos;
  }

  Future<String> _obterCombustivel() async {
    final db = await DatabaseHelper.instance.database;
    final resultado = await db.query(
      'configuracoes',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (resultado.isNotEmpty) {
      return resultado.first['tipo_combustivel'] as String;
    }

    return 'Etanol';
  }
}
