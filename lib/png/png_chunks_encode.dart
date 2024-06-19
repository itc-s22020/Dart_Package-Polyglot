import 'dart:typed_data';
import '../crc32.dart';

Uint8List pngEncodeChunks(List<Map<String, dynamic>> chunks) {
  int totalSize = 8;
  int idx = totalSize;

  for (final Map<String, dynamic> chunk in chunks) {
    totalSize += (chunk['data'] as Uint8List).length;
    totalSize += 12;
  }

  Uint8List output = Uint8List(totalSize);
  const List<int> pngHeader = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

  for (int i = 0; i < pngHeader.length; i++) {
    output[i] = pngHeader[i];
  }

  for (final Map<String, dynamic> chunk in chunks) {
    final String name = chunk['name'] as String;
    final Uint8List data = chunk['data'] as Uint8List;
    final int size = data.length;
    final List<int> nameChars = name.codeUnits.take(4).toList();

    final Uint8List sizeBytes = Uint8List(4);
    ByteData.sublistView(sizeBytes, 0, 4).setUint32(0, size, Endian.big);
    output.setRange(idx, idx + 4, sizeBytes);
    idx += 4;

    output.setAll(idx, nameChars);
    idx += nameChars.length;

    for (int j = 0; j < size; j++) {
      output[idx++] = data[j];
    }

    final List<int> crcCheck = List<int>.from(nameChars)..addAll(data);
    final int crc = Crc32.getCrc32(crcCheck);

    ByteData.sublistView(output, idx, idx + 4).setInt32(0, crc, Endian.big);
    idx += 4;
  }
    return output;
}