import 'dart:typed_data';
import 'jpeg_encode_segments.dart';
import 'jpeg_extract_segments.dart';

Uint8List jpegPolyglot(Uint8List jpegData, Uint8List polyglotData) {
  final List<Map<String, dynamic>> segments = jpegExtractSegments(jpegData);
  final List<Map<String, dynamic>> newSegments = <Map<String, dynamic>>[];

  for (final Map<String, dynamic> segment in segments) {
    final String name = segment['name'] as String;

    if (name == 'EOI') {
      newSegments.add({
        'name': 'APP15',
        'data': Uint8List.fromList([
          0xFF, 0xEF,
          (polyglotData.length + 2) >> 8, (polyglotData.length + 2) & 0xFF,
          ...polyglotData
        ])
      });
    }
    newSegments.add(segment);
  }
  return jpegEncodeSegments(newSegments);
}