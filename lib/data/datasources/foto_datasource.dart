import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


class FotoDatasource {
  final ImagePicker _picker = ImagePicker();

  Future<String?> capturarESalvar({required bool usarCamera}) async {
    final foto = await _picker.pickImage(
      source: usarCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (foto == null) return null;

    final pasta = await getApplicationDocumentsDirectory();
    final nome = 'atendimento_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final destino = p.join(pasta.path, nome);

    final comprimida = await FlutterImageCompress.compressAndGetFile(
      foto.path,
      destino,
      quality: 70,
    );

    if (comprimida == null) {
      await File(foto.path).copy(destino);
    }
    return destino;
  }
}