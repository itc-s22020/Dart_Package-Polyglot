import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/png/png_chunks_clean.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

void main() {
  late String dir;
  late final File file;
  late final String res;
  late final Uint8List data;

  setUp(() {
    dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    res = 'test/png/res';
    file = File('$dir/$res/default.png');
    data = file.readAsBytesSync();
  });

  test('clean PNG chunks', () {
    final Uint8List cleanedData = cleanChunks(data);
    final File outputFile = File('$dir/$res/cleaned.png');
    outputFile.writeAsBytesSync(cleanedData);

    final List<Map<String, dynamic>> chunks = extractChunks(cleanedData);
    for (final Map<String, dynamic> chunk in chunks) {
      expect(chunk['name'], anyOf(['IHDR', 'IDAT', 'IEND']));
    }

    expect(chunks.first['name'], 'IHDR');
    expect(chunks.last['name'], 'IEND');
    final List<Map<String, dynamic>> idatChunks = chunks.where((chunk) => chunk['name'] == 'IDAT').toList();
    expect(idatChunks.length, 1);
  });
}
