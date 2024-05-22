import 'dart:typed_data';

extension Hexadecimal on int {
  String toHex() {
    return toRadixString(16);
  }
}

String decodeBarCode(String encoded) {
  return encoded
      .replaceAll('Ý', '=')
      .replaceAll('À', ':')
      .replaceAll('¾', '.')
      .replaceAll('½', '/')
      .replaceAll(RegExp(r'\s'), '')
      .toLowerCase();
}

String hexToString(String hex) {
  String result = '';
  for (int i = 0; i < hex.length; i += 2) {
    String hexChar = hex.substring(i, i + 2);
    int charCode = int.parse(hexChar, radix: 16);
    result += String.fromCharCode(charCode);
  }
  return result;
}

String uint8ListToHex(Uint8List data) {
  return data.map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

List<String?> separateString(String str) {
  return RegExp(r'.{2}').allMatches(str).map((m) => m.group(0)).toList();
}
