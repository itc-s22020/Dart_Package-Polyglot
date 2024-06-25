import 'dart:typed_data';
import '../crc32.dart';

List<Map<String, dynamic>> pngExtractChunks(Uint8List data) {
  if (data[0] != 0x89 || data[1] != 0x50 || data[2] != 0x4E || data[3] != 0x47 ||
      data[4] != 0x0D || data[5] != 0x0A || data[6] != 0x1A || data[7] != 0x0A) {
    throw ArgumentError('Invalid .png file header');
  }

  bool ended = false;
  final List<Map<String, dynamic>> chunks = <Map<String, dynamic>>[];
  int idx = 8;

  while (idx < data.length) {
    final int uint32 = ByteData.sublistView(data, idx, idx + 4).getUint32(0, Endian.big);
    idx += 4;

    final int length = uint32 + 4;
    final Uint8List chunk = Uint8List(length);

    chunk.setRange(0, 4, data.sublist(idx, idx + 4));
    idx += 4;

    final Uint8List charCodes = chunk.sublist(0, 4);
    final String name = String.fromCharCodes(charCodes);

    if (chunks.isEmpty && name != 'IHDR') {
      throw UnsupportedError('IHDR header missing');
    }

    if (name == 'IEND') {
      ended = true;
      chunks.add({
        'name': name,
        'data': Uint8List(0),
      });
      break;
    }

    chunk.setRange(4, length, data.sublist(idx, idx + length - 4));
    idx += length - 4;

    final int crcActual = ByteData.sublistView(data, idx, idx + 4).getInt32(0, Endian.big);
    idx += 4;

    final int crcExpect = Crc32.getCrc32(chunk);
    if (crcExpect != crcActual) {
      throw UnsupportedError(
          'CRC values for $name header do not match, PNG file is likely corrupted');
    }

    final Uint8List chunkData = Uint8List.fromList(chunk.sublist(4));

    chunks.add({'name': name, 'data': chunkData});
  }

  if (!ended) {
    throw UnsupportedError(
        '.png file ended prematurely: no IEND header was found');
  }

  return chunks;
}