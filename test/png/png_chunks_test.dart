import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/png/png_extract_chunks.dart';

void main() {
  late String dir;
  late final File file;
  late final String res;
  late final Uint8List data;

  setUp((){
    dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    res = 'test/png/res';
    file = File('$dir/$res/polyglot_test.png');
    data = file.readAsBytesSync();
  });

  test('display PNG chunks', () {
    final List<Map<String, dynamic>> chunks = pngExtractChunks(data);
    for (final Map<String, dynamic> chunk in chunks) {
        if (kDebugMode) {
          print('Chunk name: ${chunk['name']}');
          print('Chunk data length: ${chunk['data'].length}');
        }
    }
  });


}
