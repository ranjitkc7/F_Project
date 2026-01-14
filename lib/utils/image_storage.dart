import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalImageStorage {
  static Future<String?> saveImage(File? image) async {
    if (image == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/student_images');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    final fileName =
        'student_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
    final savedImage = await image.copy('${imageDir.path}/$fileName');

    return savedImage.path;
  }
}
