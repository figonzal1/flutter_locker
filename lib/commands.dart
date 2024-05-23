import 'package:flutter_locker/screens/door_status.dart';
import 'package:flutter_locker/utils.dart';

class CommandBuilder {
  //HEADER
  static const READ_HEADER = "80";
  static const OPEN_HEADER = "8A";
  static const EVENT_HEADER = "81";

  static const FUNC_READ_ALL = "0033";
  static const FUNC_OPEN_DOOR = "11";

  List<String> readAllMotherBoards() {
    int nMB = 31; //Tamaño maximo de placa de 5 DIPS (31 direcciones)
    List<String> commandList = [];

    for (int i = 0; i < nMB; i++) {
      String header = READ_HEADER;
      String mb = decToHex(i + 1);
      String readAllFunction = FUNC_READ_ALL;
      String bcc = calculateBCC(header + mb + readAllFunction);

      commandList.add(header + mb + readAllFunction + bcc);
    }

    return commandList;
  }

  void openDoor(int motherBoard, int door) {
    String header = OPEN_HEADER;
    String mb_hex = decToHex(motherBoard);
    String door_hex = decToHex(door);

    String openDoorFunction = FUNC_OPEN_DOOR;
    String bcc = calculateBCC(header + mb_hex + door_hex + openDoorFunction);

    String finalCommand = header + mb_hex + door_hex + openDoorFunction + bcc;

    logger.d("Apertura de puerta: $finalCommand");
  }
}
