import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot/jpeg/jpeg_extract_segments.dart';
import 'package:polyglot/jpeg/jpeg_polyglot.dart';

void main() {
  group('Polyglot JPEG Tests', () {
    late String dir;
    late String res;
    late Uint8List jpegData;
    late Uint8List polyglotData;

    setUp(() {
      dir = Directory.current.path;
      if (dir.endsWith('/test')) {
        dir = dir.replaceAll('/test', '');
      }
      res = 'test/jpeg/res';
      jpegData = File('$dir/$res/default.jpg').readAsBytesSync();
      polyglotData = File('$dir/test/res/test.zip').readAsBytesSync();
    });
    test('JPEG segments test', () async {
      final result = jpegPolyglot(jpegData, polyglotData);

      final List<Map<String, dynamic>> segments = jpegExtractSegments(result);

      expect(segments.first['name'], 'SOI');
      expect(segments.last['name'], 'EOI');

      bool hasSos = false;
      for (final Map<String, dynamic> segment in segments) {
        expect(segment['name'], isNotEmpty);
        if (segment['name'] == 'SOS') {
          hasSos = true;
        }
      }
      expect(hasSos, isTrue, reason: 'SOS segment should be present');
    });

    test('Polyglot data in JPEG', () async {
      final result = jpegPolyglot(jpegData, polyglotData);
      final List<Map<String, dynamic>> segments = jpegExtractSegments(result);

      bool foundPolyglotInSos = false;
      for (final Map<String, dynamic> segment in segments) {
        if (segment['name'] == 'SOS') {
          Uint8List segmentData = segment['data'];
          if (containsSequence(segmentData, polyglotData)) {
            foundPolyglotInSos = true;
            break;
          }
        }
      }

      expect(foundPolyglotInSos, isTrue, reason: 'Polyglot data should be found in SOS segment');
    });

    test('JPEG check', () async {
      final result = jpegPolyglot(jpegData, polyglotData);
      final outputFile = File('$dir/$res/polyglot_test.jpg');
      await outputFile.writeAsBytes(result);

      expect(result.sublist(0, 2), equals(jpegData.sublist(0, 2)));

      final savedFileData = await outputFile.readAsBytes();
      expect(savedFileData, equals(result));
    });

    test('JPEG segments test', () async {
      final result = jpegPolyglot(jpegData, polyglotData);

      final List<Map<String, dynamic>> segments = jpegExtractSegments(result);
      expect(segments.first['name'], 'SOI');
      expect(segments.last['name'], 'EOI');

      bool hasSos = false;
      for (final Map<String, dynamic> segment in segments) {
        expect(segment['name'], isNotEmpty);
        if (segment['name'] == 'SOS') {
          hasSos = true;
        }
      }
      expect(hasSos, isTrue, reason: 'SOS segment should be present');
    });

    test('Polyglot data in JPEG', () async {
      final result = jpegPolyglot(jpegData, polyglotData);
      final List<Map<String, dynamic>> segments = jpegExtractSegments(result);

      bool foundPolyglotInSos = false;
      for (final Map<String, dynamic> segment in segments) {
        if (segment['name'] == 'SOS') {
          Uint8List segmentData = segment['data'];
          if (containsSequence(segmentData, polyglotData)) {
            foundPolyglotInSos = true;
            break;
          }
        }
      }

      expect(foundPolyglotInSos, isTrue, reason: 'Polyglot data should be found in SOS segment');
    });
  });
}

bool containsSequence(Uint8List haystack, Uint8List needle) {
  if (needle.length > haystack.length) return false;
  for (int i = 0; i <= haystack.length - needle.length; i++) {
    bool found = true;
    for (int j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) {
        found = false;
        break;
      }
    }
    if (found) return true;
  }
  return false;
}