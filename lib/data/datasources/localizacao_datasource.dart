import 'package:geolocator/geolocator.dart';


class LocalizacaoDatasource {
  
  Future<Position?> buscarPosicaoAtual() async {
    final servicoLigado = await Geolocator.isLocationServiceEnabled();
    if (!servicoLigado) return null;

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  double calcularDistanciaKm(double lat1, double lon1, double lat2, double lon2) {
    final metros = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return metros / 1000;
  }
}