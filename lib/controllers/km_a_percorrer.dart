class CalcularDistancia {
  double calcularDistancia(double litros, double distancia) {
    double kmPercorrer = 0.0;

    if (distancia >= 500) {
        kmPercorrer = litros * 7; // Acima de 480 km
        print('media 7' );
    } else if (distancia >= 225) {
        kmPercorrer = litros * 6; // Acima de 300 km
        print('media 6');
    } else {
        kmPercorrer = litros * 5; // Acima de 10 km
        print('meida 5');

    }
    return kmPercorrer;
  }
}
