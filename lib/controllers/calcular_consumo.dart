/*
Classe para calcular o consumo em litros para controle
de abastecimento
*/

class CalcularConsumo {
  double calcularConsumo(double distancia, double litrosAbastecidos) {
    double litrosNecessarios = 0.0, litrosRestantes = 0.0;
    if (litrosAbastecidos < 1) {
      litrosAbastecidos = 1;
    }

    if (distancia >= 500) {
      litrosNecessarios = distancia / 7; // Acima de 480 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    } else if (distancia < 500 && distancia >= 225) {
      litrosNecessarios = distancia / 6; // Acima de 300 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    } else {
      litrosNecessarios = distancia / 5.0; // Acima de 10 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    }

    return litrosRestantes;
  }
}
