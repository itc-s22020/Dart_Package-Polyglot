import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/jpeg/jpeg_encode_segments.dart';
import 'package:polyglot/jpeg/jpeg_extract_segments.dart';

void main() {
  late String dir;
  late final File file;
  late final String res;
  late final Uint8List data;

  setUp(() {
    dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    res = 'test/jpeg/res';
    file = File('$dir/$res/default.jpg');
    data = file.readAsBytesSync();
  });

  test('encode and decode JPEG segments', () {
    final List<Map<String, dynamic>> segments = jpegExtractSegments(data);
    final Uint8List encodedData = jpegEncodeSegments(segments);

    expect(encodedData, equals(data));
  });
}