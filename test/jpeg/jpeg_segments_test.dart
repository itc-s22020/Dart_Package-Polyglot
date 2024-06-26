import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
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
    file = File('$dir/$res/polyglot_test.jpg');
    data = file.readAsBytesSync();
  });

  test('display JPEG segments', () {
    final List<Map<String, dynamic>> segments = jpegExtractSegments(data);
    for (final Map<String, dynamic> segment in segments) {
      if (kDebugMode) {
        print('Segment name: ${segment['name']}');
        print('Segment data length: ${segment['data'].length}');
      }
    }
  });
}