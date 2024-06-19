import 'dart:typed_data';
import 'package:polyglot/png/png_chunks_clean.dart';
import 'package:polyglot/png/png_chunks_encode.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

Uint8List pngPolyglot(Uint8List pngData, Uint8List polyglotData) {
  final Uint8List cleanedPngData = pngCleanChunks(pngData);
  final List<Map<String, dynamic>> chunks = pngExtractChunks(cleanedPngData);

  final List<Map<String, dynamic>> essentialChunks = <Map<String, dynamic>>[];
  final List<int> idatData = <int>[];

  for (final Map<String, dynamic> chunk in chunks) {
    final String name = chunk['name'] as String;
    if (name == 'IHDR' || name == 'IDAT' || name == 'IEND') {
      if (name == 'IDAT') {
        idatData.addAll(chunk['data'] as Uint8List);
      } else {
        essentialChunks.add(chunk);
      }
    }
  }

  idatData.addAll(polyglotData);
  final Map<String, Object> idatChunk = {
    'name': 'IDAT',
    'data': Uint8List.fromList(idatData),
  };
  essentialChunks.insert(essentialChunks.length - 1, idatChunk);

  return pngEncodeChunks(essentialChunks);
}

