class CalcularConsumo {
  double calcularConsumo(double distancia, double litrosAbastecidos) {
    double litrosNecessarios = 0.0, litrosRestantes = 0.0;

    if (distancia > 500) {
      litrosNecessarios = distancia / 7.0; // Acima de 480 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    } else if (distancia <= 500) {
      litrosNecessarios = distancia / 6.0; // Acima de 300 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    } else if (distancia <= 225) {
      litrosNecessarios = distancia / 5.0; // Acima de 10 km
      litrosRestantes = litrosNecessarios - litrosAbastecidos;
    }
    return litrosRestantes;
  }
}
