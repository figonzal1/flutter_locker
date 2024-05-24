import 'package:flutter_locker/utils.dart';

class CommandBuilder {
  //HEADER
  static const READ_HEADER = "80";
  static const OPEN_HEADER = "8A";
  static const EVENT_HEADER = "81";

  static const FUNC_READ_ALL = "0033";
  static const FUNC_OPEN_DOOR = "11";

  ///Funcion para construir comandos hexadecimales de escaneo de placas
  ///
  ///**Parámetros:**
  ///* N° de placas a escanear [nMotherBoard]
  ///
  ///*Para placas de 5 DIPS, n° máximo de placas a escanear = 31*
  static List<String> scanAllMotherBoards({int nMotherBoards = 31}) {
    List<String> commandList = [];

    for (int i = 0; i < nMotherBoards; i++) {
      String header = READ_HEADER;
      String mb = decToHex(i + 1);
      String readAllFunction = FUNC_READ_ALL;
      String bcc = calculateBCC(header + mb + readAllFunction);

      commandList.add(header + mb + readAllFunction + bcc);
    }

    return commandList;
  }

  ///Función para construir comando hexadecimal de escaneo de una placa
  ///
  ///**Parámetros**
  ///* ID de placa a escanear [idMb]
  static String scanMotherBoardById({required int idMb}) {
    String header = READ_HEADER;
    String mb = decToHex(idMb);
    String readFunction = FUNC_READ_ALL;
    String bcc = calculateBCC(header + mb + readFunction);

    String finalCommand = header + mb + readFunction + bcc;
    return finalCommand;
  }

  ///Funcion para construir comandos de apertura de locker box
  ///
  ///**Parámetros:**
  ///* ID de placa [idMb]
  ///
  ///* ID del locker box [idLockerBox]
  ///
  ///Retorna comando de apertura en `HEX`
  static String openLockerBox(int idMb, int idLockerBox) {
    String header = OPEN_HEADER;
    String mbHex = decToHex(idMb);
    String lockerBoxHex = decToHex(idLockerBox);

    String openDoorFunction = FUNC_OPEN_DOOR;
    String bcc = calculateBCC(header + mbHex + lockerBoxHex + openDoorFunction);

    String finalCommand =
        header + mbHex + lockerBoxHex + openDoorFunction + bcc;

    return finalCommand;
  }
}
