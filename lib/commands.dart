import 'package:flutter_locker/utils.dart';

class CommandBuilder {
  //HEADER
  static const READ_HEADER = "80";
  static const OPEN_HEADER = "8A";
  static const EVENT_HEADER = "81";

  static const READ_ALL_MB = "0033";

  List<String> readAllMotherBoards() {

    int nMB = 31; //Tamaño maximo de placa de 5 DIPS (31 direcciones)
    List<String> commandList = [];

    for (int i = 0; i < nMB; i++) {
      String header = READ_HEADER;
      String mb = decToHex(i + 1);
      String readAllFunction = READ_ALL_MB;
      String bcc = calculateBCC(header + mb + readAllFunction);

      commandList.add(header + mb + readAllFunction + bcc);
    }

    return commandList;
  }
}
