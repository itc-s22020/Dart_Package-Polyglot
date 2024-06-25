String getJpegMarkerName(int markerType) {
  switch (markerType) {
    case 0x00: return 'Data_FF';  // データとしてのFF
    case 0x01: return 'TEM';      // 算術符号用テンポラリ
    case 0x02: case 0x03: case 0x04: case 0x05: case 0x06: case 0x07:
    case 0x08: case 0x09: case 0x0A: case 0x0B: case 0x0C: case 0x0D:
    case 0x0E: case 0x0F: case 0x10: case 0x11: case 0x12: case 0x13:
    case 0x14: case 0x15: case 0x16: case 0x17: case 0x18: case 0x19:
    case 0x1A: case 0x1B: case 0x1C: case 0x1D: case 0x1E: case 0x1F:
    case 0x20: case 0x21: case 0x22: case 0x23: case 0x24: case 0x25:
    case 0x26: case 0x27: case 0x28: case 0x29: case 0x2A: case 0x2B:
    case 0x2C: case 0x2D: case 0x2E: case 0x2F: case 0x30: case 0x31:
    case 0x32: case 0x33: case 0x34: case 0x35: case 0x36: case 0x37:
    case 0x38: case 0x39: case 0x3A: case 0x3B: case 0x3C: case 0x3D:
    case 0x3E: case 0x3F: case 0x40: case 0x41: case 0x42: case 0x43:
    case 0x44: case 0x45: case 0x46: case 0x47: case 0x48: case 0x49:
    case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E:
    return 'RES';  // リザーブ
    case 0x4F: return 'SOC';  // コードストリーム開始(JPEG2000)
    case 0x51: return 'SIZ';  // サイズ定義(JPEG2000)
    case 0x52: return 'COD';  // 符号化標準定義(JPEG2000)
    case 0x53: return 'COC';  // 符号化個別定義(JPEG2000)
    case 0x55: return 'TLM';  // タイルパート長定義(JPEG2000)
    case 0x57: return 'PLM';  // パケット長標準定義(JPEG2000)
    case 0x58: return 'PLT';  // パケット長個別定義(JPEG2000)
    case 0x5C: return 'QCD';  // 量子化標準定義(JPEG2000)
    case 0x5D: return 'QCC';  // 量子化個別定義(JPEG2000)
    case 0x5E: return 'RGN';  // ROI定義(JPEG2000)
    case 0x5F: return 'POC';  // プログレッション順序変更(JPEG2000)
    case 0x60: return 'PPM';  // パケットヘッダー標準定義(JPEG2000)
    case 0x61: return 'PPT';  // パケットヘッダー個別定義(JPEG2000)
    case 0x63: return 'CRG';  // コンポーネント位相定義(JPEG2000)
    case 0x64: return 'COM';  // コメント(JPEG2000)
    case 0x90: return 'SOT';  // タイルパート開始(JPEG2000)
    case 0x91: return 'SOP';  // パケット開始(JPEG2000)
    case 0x92: return 'EPH';  // パケットヘッダー終了(JPEG2000)
    case 0x93: return 'SOD';  // データ開始(JPEG2000)
    case 0xC0: return 'SOF0';  // ベースライン フレームヘッダー
    case 0xC1: return 'SOF1';  // 拡張シーケンシャルDCT
    case 0xC2: return 'SOF2';  // プログレッシブDCT
    case 0xC3: return 'SOF3';  // ロスレス
    case 0xC4: return 'DHT';   // ハフマンテーブル定義
    case 0xC5: return 'SOF5';  // 差分シーケンシャルDCT
    case 0xC6: return 'SOF6';  // 差分プログレッシブDCT
    case 0xC7: return 'SOF7';  // 差分ロスレス
    case 0xC8: return 'JPG';   // JPEG拡張用リザーブ
    case 0xC9: return 'SOF9';  // 拡張シーケンシャルDCT (算術符号化)
    case 0xCA: return 'SOF10'; // プログレッシブDCT (算術符号化)
    case 0xCB: return 'SOF11'; // ロスレス (算術符号化)
    case 0xCC: return 'DAC';   // 算術符号テーブル定義
    case 0xCD: return 'SOF13'; // 差分シーケンシャルDCT (算術符号化)
    case 0xCE: return 'SOF14'; // 差分プログレッシブDCT (算術符号化)
    case 0xCF: return 'SOF15'; // 差分ロスレス (算術符号化)
    case 0xD0: case 0xD1: case 0xD2: case 0xD3:
    case 0xD4: case 0xD5: case 0xD6: case 0xD7:
    return 'RST${markerType - 0xD0}';  // リスタートマーカ
    case 0xD8: return 'SOI';   // スタートマーカ
    case 0xD9: return 'EOI';   // エンドマーカ / コードストリーム終了(JPEG2000)
    case 0xDA: return 'SOS';   // スキャンヘッダー
    case 0xDB: return 'DQT';   // 量子化テーブル定義
    case 0xDC: return 'DNL';   // ライン数定義
    case 0xDD: return 'DRI';   // リスタートインタバル定義
    case 0xDE: return 'DHP';   // ハイアラーキカルプログレッション定義
    case 0xDF: return 'EXP';   // 成分拡大
    case 0xE0: case 0xE1: case 0xE2: case 0xE3: case 0xE4: case 0xE5:
    case 0xE6: case 0xE7: case 0xE8: case 0xE9: case 0xEA: case 0xEB:
    case 0xEC: case 0xED: case 0xEE: case 0xEF:
    return 'APP${markerType - 0xE0}';  // アプリケーション用
    case 0xF0: case 0xF1: case 0xF2: case 0xF3: case 0xF4: case 0xF5:
    case 0xF6: case 0xF7: case 0xF8: case 0xF9: case 0xFA: case 0xFB:
    case 0xFC: case 0xFD:
    return 'JPG${markerType - 0xF0}';  // JPEG拡張用リザーブ
    case 0xFE: return 'COM';   // コメント
    case 0xFF: return 'Ignored_FF';  // FFの連続は最後のFFを除いて無視
    default:
      return 'Unknown_${markerType.toRadixString(16).toUpperCase().padLeft(2, '0')}';
  }
}