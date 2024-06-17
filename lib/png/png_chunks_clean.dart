import 'dart:typed_data';
import '../crc32.dart';
import 'package:archive/archive.dart' hide Crc32;
import 'package:polyglot/png/png_chunks_encode.dart';
import 'package:polyglot/png/png_chunks_extract.dart';

Uint8List cleanChunks(Uint8List data) {
  var chunks = extractChunks(data);
  var necessaryChunks = <Map<String, dynamic>>[];
  var idatData = <int>[];

  for (var chunk in chunks) {
    var name = chunk['name'] as String;
    if (name == 'IHDR' || name == 'IEND') {
      necessaryChunks.add(chunk);
    } else if (name == 'IDAT') {
      idatData.addAll(chunk['data'] as Uint8List);
    }
  }

  if (idatData.isNotEmpty) {
    var decompressedData = const ZLibDecoder().decodeBytes(Uint8List.fromList(idatData));
    var compressedData = const ZLibEncoder().encode(Uint8List.fromList(decompressedData));


    if (compressedData.isNotEmpty) {
      var crc = Crc32.getCrc32(compressedData);
      necessaryChunks.insert(1, {'name': 'IDAT', 'data': Uint8List.fromList(compressedData)});

      var crcBytes = Uint8List(4);
      ByteData.sublistView(crcBytes, 0, 4).setUint32(0, crc, Endian.big);
      necessaryChunks[1]['crc'] = crcBytes;
    }
  }

  return encodeChunks(necessaryChunks);
}