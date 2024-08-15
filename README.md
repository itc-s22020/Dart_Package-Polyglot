# Dart-Polyglot

**Dart-Polyglot** は、Flutter用に作成されたポリグロット画像を生成するパッケージです。PNGおよびJPEGをサポート。画像内にはZIP形式のファイルを埋め込むことのみを想定しています。このパッケージは100% Dartで構成されています。

### Supported Formats
- **PNG**
- **JPEG**

詳細なドキュメントについては、[GitHub Wiki](https://github.com/itc-s22020/Dart-Polyglot/wiki)を参照してください。
## Install
Supported Formats
プロジェクトの``pubspec.yaml``にパッケージを追加
```yaml
dependencies:
  polyglot:
    git:
      url: https://github.com/itc-s22020/Dart-Polyglot.git
```

依存関係をインストール
```shell
flutter pub get
```
## Usage

### PNG
- シンプルなポリグロットファイルの生成
```Dart
final Uint8List pngData = png as Uint8List;
final Uint8List polyglotData = zip as Uint8List;
final Uint8List polyglot = pngPolyglot(pngData, polyglotData);
```
- チャンク構造の単純化 (IHDR、IDAT、IENDのみに変換)
```Dart
final Uint8List pngData = png as Uint8List;
final Uint8List cleanData = pngCleanChunks(pngData);
```
- チャンク構造の抽出
```Dart
final Uint8List pngData = png as Uint8List;
final List<Map<String, dynamic>> chunks = pngExtractChunks(pngData);
```
- チャンク構造から画像を構築
```Dart 
final List<Map<String, dynamic>> customChunks = chunks;
final Uint8List png = pngEncodeChunks(customChunks);
```

### JPEG
- シンプルなポリグロットファイルの生成
```Dart
final Uint8List jpegData = jpeg as Uint8List;
final Uint8List polyglotData = zip as Uint8List;
final Uint8List polyglot = jpegPolyglot(jpegData, polyglotData);
```
- セグメント構造の抽出
```Dart
final Uint8List jpegData = jpeg as Uint8List;
final List<Map<String, dynamic>> segments = jpegExtractSegments(jpegData);
//未知のセグメントはUnknown_FFFFのような形式で返します
```
- セグメント構造から画像を構築
```Dart
final List<Map<String, dynamic>> customSegments = segments;
final Uint8List jpeg = jpegEncodeSegments(customSegments);
```
### データ構造( List<Map<String, dynamic>> )
- チャンク構造 (PNG)
```Dart
final List<Map<String, dynamic>> chunks = [
  { 'name': 'IHDR', 'data': Uint8List([...]) },
  { 'name': 'IDAT', 'data': Uint8List([...]) },
  { 'name': 'IEND', 'data': Uint8List([]) },
];
```
- セグメント構造 (JPEG)
```Dart
final List<Map<String, dynamic>> segments = [
  { 'name': 'SOI', 'data': Uint8List([...]) },
  { 'name': 'DQT', 'data': Uint8List([...]) },
  { 'name': 'DHT', 'data': Uint8List([...]) },
  { 'name': 'SOF', 'data': Uint8List([...]) },
  { 'name': 'SOS', 'data': Uint8List([...]) },
  { 'name': 'EOI', 'data': Uint8List([]) },
];
```
