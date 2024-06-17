import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/png/png_chunks_clean.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

void main() {
  test('clean PNG chunks', () {
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }

    File file = File('$dir/test/png/res/default.png');
    final data = file.readAsBytesSync();
    Uint8List cleanedData = cleanChunks(data);

    File outputFile = File('$dir/test/png/res/cleaned.png');
    outputFile.writeAsBytesSync(cleanedData);

    List<Map<String, dynamic>> chunks = extractChunks(cleanedData);
    for (var chunk in chunks) {
      expect(chunk['name'], anyOf(['IHDR', 'IDAT', 'IEND']));
    }

    expect(chunks.first['name'], 'IHDR');
    expect(chunks.last['name'], 'IEND');
    var idatChunks = chunks.where((chunk) => chunk['name'] == 'IDAT').toList();
    expect(idatChunks.length, 1);
  });
}
