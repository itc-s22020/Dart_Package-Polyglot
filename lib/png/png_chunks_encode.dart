import 'dart:typed_data';
import '../crc32.dart';

Uint8List encodeChunks(List<Map<String, dynamic>> chunks) {
  int totalSize = 8;
  int idx = totalSize;

  for (var chunk in chunks) {
    totalSize += (chunk['data'] as Uint8List).length;
    totalSize += 12;
  }

  var output = Uint8List(totalSize);
  var pngHeader = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

  for (var i = 0; i < pngHeader.length; i++) {
    output[i] = pngHeader[i];
  }

  for (var chunk in chunks) {
    var name = chunk['name'] as String;
    var data = chunk['data'] as Uint8List;
    var size = data.length;
    var nameChars = name.codeUnits.take(4).toList();

    var sizeBytes = Uint8List(4);
    ByteData.sublistView(sizeBytes, 0, 4).setUint32(0, size, Endian.big);
    output.setRange(idx, idx + 4, sizeBytes);
    idx += 4;

    output.setAll(idx, nameChars);
    idx += nameChars.length;

    for (var j = 0; j < size; j++) {
      output[idx++] = data[j];
    }

    var crcCheck = List<int>.from(nameChars)
      ..addAll(data);
    var crc = Crc32.getCrc32(crcCheck);

    ByteData.sublistView(output, idx, idx + 4).setInt32(0, crc, Endian.big);
    idx += 4;
  }
    return output;
}