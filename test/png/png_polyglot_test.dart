import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/png/png_chunks_extract.dart';
import 'package:polyglot/png/png_polyglot.dart';

void main() {
  group('Polyglot PNG Tests', () {
    late String dir;
    late String res;
    late Uint8List pngData;
    late Uint8List polyglotData;

    setUp(() {
      dir = Directory.current.path;
      if (dir.endsWith('/test')) {
        dir = dir.replaceAll('/test', '');
      }
      res = 'test/png/res';
      pngData = File('$dir/$res/default.png').readAsBytesSync();
      polyglotData = File('$dir/$res/test.zip').readAsBytesSync();
    });



    test('PNG check', () async {
      final result = pngPolyglot(pngData, polyglotData);
      final outputFile = File('$dir/$res/polyglot_test.png');
      await outputFile.writeAsBytes(result);

      expect(result.sublist(0, 8), equals(pngData.sublist(0, 8)));

      final savedFileData = await outputFile.readAsBytes();
      expect(savedFileData, equals(result));
    });


    test('PNG chunks test', () async {
      final result = pngPolyglot(pngData, polyglotData);

      final List<Map<String, dynamic>> chunks = pngExtractChunks(result);
      for (final Map<String, dynamic> chunk in chunks) {
        expect(chunk['name'], anyOf(['IHDR', 'IDAT', 'IEND']));
      }

      expect(chunks.first['name'], 'IHDR');
      expect(chunks.last['name'], 'IEND');
      final List<Map<String, dynamic>> idatChunks = chunks.where((chunk) => chunk['name'] == 'IDAT').toList();
      expect(idatChunks.length, 1);
    });

    test('PNG in polyglotData', () async {
      final result = pngPolyglot(pngData, polyglotData);
      final List<Map<String, dynamic>> chunks = pngExtractChunks(result);

      bool foundPolyglotInIdat = false;
      for (final Map<String, dynamic> chunk in chunks) {
        if (chunk['name'] == 'IDAT') {
          List<int> chunkData = chunk['data'];
          if (polyglotData.every((element) => chunkData.contains(element))) {
            foundPolyglotInIdat = true;
            break;
          }
        }
      }

      expect(foundPolyglotInIdat, isTrue);
    });

  });
}
