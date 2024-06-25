import 'dart:typed_data';
import '../crc32.dart';
import 'package:archive/archive.dart' hide Crc32;
import 'package:polyglot/png/png_encode_chunks.dart';
import 'package:polyglot/png/png_extract_chunks.dart';


Uint8List pngCleanChunks(Uint8List data) {
  final List<Map<String, dynamic>> chunks = pngExtractChunks(data);
  final List<Map<String, dynamic>> essentialChunks = <Map<String, dynamic>>[];
  final List<int> idatData = <int>[];

  for (final Map<String, dynamic> chunk in chunks) {
    final String name = chunk['name'] as String;
    if (name == 'IHDR' || name == 'IEND') {
      essentialChunks.add(chunk);
    } else if (name == 'IDAT') {
      idatData.addAll(chunk['data'] as Uint8List);
    }
  }

  if (idatData.isNotEmpty) {
    try {
      final List<int> decompressedData = const ZLibDecoder().decodeBytes(Uint8List.fromList(idatData));
      final List<int> compressedData = const ZLibEncoder().encode(Uint8List.fromList(decompressedData));

      if (compressedData.isNotEmpty) {
        final int crc = Crc32.getCrc32(compressedData);
        Uint8List crcBytes = Uint8List(4);
        ByteData.sublistView(crcBytes, 0, 4).setUint32(0, crc, Endian.big);
        essentialChunks.insert(1, {
          'name': 'IDAT',
          'data': Uint8List.fromList(compressedData),
          'crc': crcBytes
        });
      }
    } catch (e) {
      throw UnsupportedError('Error processing IDAT data: $e');
    }
  }

  return pngEncodeChunks(essentialChunks);
}