import 'dart:typed_data';
import 'jpeg_marker_name.dart';

List<Map<String, dynamic>> jpegExtractSegments(Uint8List data) {
  if (data[0] != 0xFF || data[1] != 0xD8) {
    throw ArgumentError('Invalid JPEG file header');
  }

  final segments = <Map<String, dynamic>>[];
  var idx = 0;

  while (idx < data.length - 1) {
    if (data[idx] != 0xFF) {
      idx++;
      continue;
    }

    final markerType = data[idx + 1];
    final name = getJpegMarkerName(markerType);

    switch (markerType) {
      case 0xD8:
      case 0xD9:
        segments.add({
          'name': name,
          'data': Uint8List.fromList([0xFF, markerType]),
        });
        idx += 2;
        if (markerType == 0xD9) return segments;
        break;

      case 0xDA:
        final sosStart = idx;
        idx += 2;
        while (idx < data.length - 1 && !(data[idx] == 0xFF && data[idx + 1] == 0xD9)) {
          idx++;
        }
        if (idx == data.length - 1) {
          throw UnsupportedError('JPEG file ended prematurely: no EOI marker found');
        }
        segments.add({
          'name': name,
          'data': Uint8List.fromList(data.sublist(sosStart, idx)),
        });
        break;

      default:
        idx += 2;
        final length = ByteData.sublistView(data, idx, idx + 2).getUint16(0, Endian.big);
        segments.add({
          'name': name,
          'data': Uint8List.fromList(data.sublist(idx - 2, idx + length)),
        });
        idx += length;
    }
  }

  return segments;
}