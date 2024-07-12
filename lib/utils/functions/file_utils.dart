import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<File?> saveUint8ListToFile(Uint8List? data, int id) async {
  if (data == null) {
    return null;
  }
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/song_$id.png';
    final file = File(filePath);
    await file.writeAsBytes(data);
    log('file saved at ${file.uri}');
    return file;
  } on Exception catch (e) {
    log(e.toString());
  }
  return null;
}

Future<String> getThumbDirectoryPath() async {
  final directory = await getApplicationDocumentsDirectory();
  // final filePath = '${directory.path}/song_$id.png';
  log('getThumbPath : $directory');
  return directory.path;
}
