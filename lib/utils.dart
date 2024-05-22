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
