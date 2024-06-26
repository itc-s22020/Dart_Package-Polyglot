import 'dart:typed_data';

Uint8List jpegEncodeSegments(List<Map<String, dynamic>> segments) {
  int totalSize = 0;
  for (final segment in segments) {
    totalSize += (segment['data'] as Uint8List).length;
  }

  Uint8List output = Uint8List(totalSize);
  int idx = 0;

  for (final segment in segments) {
    final Uint8List data = segment['data'] as Uint8List;
    for (int i = 0; i < data.length; i++) {
      output[idx++] = data[i];
    }
  }

  return output;
}