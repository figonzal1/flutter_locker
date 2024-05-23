import 'dart:typed_data';

///Convertir numero decimal a hexadecimal
/// Ejemplo: Dec '24' -> Hex '18'
String decToHex(int number) => number.toRadixString(16);

///Convertir hexadecimal a decimal
/// Ejemplo: '9A' -> 154
int hexToDec(String hex) => int.parse(hex, radix: 16);

///Convertir uint8List a hexadecimal
String uint8ListToHex(Uint8List data) {
  return data.map((byte) => decToHex(byte).padLeft(2, '0')).join('');
}

///Convertir hexadecimal a uint8List
Uint8List hexToUint8List(String hex) {
  hex = cleanHex(hex);

  // Asegúrate de que la longitud de la cadena sea par
  if (hex.length % 2 != 0) return Uint8List(0);

  final length = hex.length ~/ 2;
  final bytes = Uint8List(length);

  for (int i = 0; i < length; i++) {
    final byteStr = hex.substring(i * 2, i * 2 + 2);
    final byte = hexToDec(byteStr);
    bytes[i] = byte;
  }

  return bytes;
}

///Convertir un hexadecimal a una lista de pares de hexadecimales
///Ejemplo: '8A0101119B' => ['8A','01','01','11','9B']
Map<String, String> separateHex(String str) {
  str = cleanHex(str);

  final Map<String, String> hexMap = {};
  final keys = ['header', 'motherboard', 'channel', 'function', 'bcc'];
  final matches = RegExp(r'.{2}').allMatches(str).toList();

  if (matches.length == keys.length) {
    for (int i = 0; i < keys.length && i < matches.length; i++) {
      hexMap[keys[i]] = matches[i].group(0) ?? '';
    }
  }
  return hexMap;
}

///Convertir valor hexadecimal a una string list
List<String> hexToList(String hexString) {
  hexString = cleanHex(hexString);

  List<String> bytes = [];
  for (int i = 0; i < hexString.length; i += 2) {
    bytes.add(hexString.substring(i, i + 2));
  }

  return bytes;
}

///Limpiar strings de QR
String decodeBarCode(String encoded) => encoded
    .replaceAll('Ý', '=')
    .replaceAll('À', ':')
    .replaceAll('¾', '.')
    .replaceAll('½', '/')
    .replaceAll(RegExp(r'\s'), '')
    .toLowerCase();

///Limpiar espacios en blanco de los comandos
String cleanHex(String hex) => hex.replaceAll(RegExp(r'\s'), '');

///BCC CHECKSUM function
///Parametro hex a recibir
String calculateBCC(String hex) {
  hex = cleanHex(hex);

  //Hex to decimal list
  List<int> bytes = [];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(hexToDec(hex.substring(i, i + 2)));
  }

  int bcc = 0;
  for (int i = 0; i < bytes.length; i++) {
    bcc ^= bytes[i];
  }

  return decToHex(bcc);
}
