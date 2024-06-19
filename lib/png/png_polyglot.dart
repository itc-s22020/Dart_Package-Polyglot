import 'dart:convert';
import 'dart:typed_data';
import 'package:polyglot/png/png_chunks_clean.dart';
import 'package:polyglot/png/png_chunks_encode.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

Uint8List pngPolyglot(Uint8List pngData, Uint8List polyglotData) {
  // Clean the PNG chunks first
  final Uint8List cleanedPngData = pngCleanChunks(pngData);
  List<Map<String, dynamic>> chunks = pngExtractChunks(cleanedPngData);

  List<Map<String, dynamic>> essentialChunks = <Map<String, dynamic>>[];
  List<int> idatData = <int>[];

  // Extract necessary chunks and IDAT data
  for (Map<String, dynamic> chunk in chunks) {
    var name = chunk['name'] as String;
    if (name == 'IHDR' || name == 'IDAT' || name == 'IEND') {
      if (name == 'IDAT') {
        idatData.addAll(chunk['data'] as Uint8List);
      } else {
        essentialChunks.add(chunk);
      }
    }
  }

  // Append the ZIP data to the IDAT data
  idatData.addAll(polyglotData);

  // Create the new IDAT chunk with the appended ZIP data
  var idatChunk = {
    'name': 'IDAT',
    'data': Uint8List.fromList(idatData),
  };
  essentialChunks.insert(essentialChunks.length - 1, idatChunk);

  return pngEncodeChunks(essentialChunks);
}

