import 'package:controle_km/controllers/calcular_consumo.dart';
import 'package:controle_km/data/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('CalcularConsumo', () {
    late CalcularConsumo calcularConsumo;

    setUp(() async {
      calcularConsumo = CalcularConsumo();
      await DatabaseHelper.instance.salvarCombustivelNoBanco('Etanol');
    });

    test('calcula o consumo para distancias menores que 225 km', () async {
      final resultado = await calcularConsumo.calcularConsumo(100, 10);

      expect(resultado, closeTo(10, 0.0001));
    });

    test('calcula o consumo para distancias entre 225 e 499 km', () async {
      final resultado = await calcularConsumo.calcularConsumo(300, 20);

      expect(resultado, closeTo(30, 0.0001));
    });

    test('calcula o consumo para distancias a partir de 500 km', () async {
      final resultado = await calcularConsumo.calcularConsumo(500, 20);

      expect(resultado, closeTo(500 / 7 - 20, 0.0001));
    });

    test('considera 1 litro quando o abastecimento é menor que 1 litro',
        () async {
      final resultado = await calcularConsumo.calcularConsumo(100, 0.5);

      expect(resultado, closeTo(19, 0.0001));
    });

    test('usa o rendimento da gasolina salvo no banco', () async {
      await DatabaseHelper.instance.salvarCombustivelNoBanco('Gasolina');

      final resultado = await calcularConsumo.calcularConsumo(100, 5);

      expect(resultado, closeTo(7.5, 0.0001));
    });

    test('usa o rendimento do diesel salvo no banco', () async {
      await DatabaseHelper.instance.salvarCombustivelNoBanco('Diesel');

      final resultado = await calcularConsumo.calcularConsumo(100, 5);

      expect(resultado, closeTo(5, 0.0001));
    });
  });
}
