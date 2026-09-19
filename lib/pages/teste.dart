
import 'package:controle_km/data/database_helper.dart';
class CalcularConsumo {
  // O método passa a ser assíncrono (async) e retorna Future<double>
  Future<double> calcularConsumo(double distancia,double litrosAbastecidos,
  ) async {
    // 1. Busca o combustível diretamente da tabela 'configuracoes'
    String tipoCombustivel = await _obterCombustivel();

    if (litrosAbastecidos < 1) {
      litrosAbastecidos = 1;
    }

    // 2. Define o consumo (km por litro) com base no combustível
    double consumoLonga, consumoMedia, consumoCurta;

    switch (tipoCombustivel) {
      case 'Gasolina':
        consumoLonga = 12.0;
        consumoMedia = 10.0;
        consumoCurta = 8.0;
        break;

      case 'Diesel':
        consumoLonga = 15.0;
        consumoMedia = 13.0;
        consumoCurta = 10.0;
        break;

      case 'Etanol':
      default:
        // Mantém as proporções padrão da sua regra original (7, 6 e 5)
        consumoLonga = 7.0;
        consumoMedia = 6.0;
        consumoCurta = 5.0;
        break;
    }

    // 3. Aplica o cálculo considerando a distância e o rendimento do combustível
    double litrosNecessarios = 0.0;

    if (distancia >= 500) {
      litrosNecessarios = distancia / consumoLonga;
    } else if (distancia < 500 && distancia >= 225) {
      litrosNecessarios = distancia / consumoMedia;
    } else {
      litrosNecessarios = distancia / consumoCurta;
    }

    double litrosRestantes = litrosNecessarios - litrosAbastecidos;

    return litrosRestantes;
  }

  // Método auxiliar privado para buscar o registro da tabela 'configuracoes'
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

    // Valor padrão de segurança caso a tabela esteja vazia
    return 'Etanol';
  }
}