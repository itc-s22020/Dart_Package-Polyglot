import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

void main() {
  test('display PNG chunks', () {
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }

    File file = File('$dir/test/png/res/cleaned.png');
    final data = file.readAsBytesSync();
    final chunks = extractChunks(data);

    for (var chunk in chunks) {
        print('Chunk name: ${chunk['name']}');
        print('Chunk data length: ${chunk['data'].length}');
    }
  });
}
