import 'package:flutter_locker/commands.dart';
import 'package:flutter_locker/utils.dart';
import 'package:logger/logger.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

var logger = Logger();

const CMD_SELECT_ALL_STATES_SIZE = 8;

typedef Callback = void Function(int place);

class Locker {
  late List<String> ports;
  late SerialPort port;

  void _getPorts() {
    ports = SerialPort.getAvailablePorts();
    logger.d("Detected ports: $ports");
  }

  bool tryToConnect() {
    _getPorts();

    if (ports.isNotEmpty && ports.first.isNotEmpty) {
      final firstPort = ports.first;

      port = SerialPort(firstPort,
          openNow: true, BaudRate: 9600, ByteSize: 8, StopBits: 1);

      if (port.isOpened) {
        logger.d("Puerto $firstPort: abierto correctamente");
        return true;
      } else {
        logger.e("Puerto $firstPort: conexión fallida");
        return false;
      }
    } else {
      logger.f("Puertos vacios");
      return false;
    }
  }

  void listenEvents(Callback callback) {
    if (port.isOpened) {
      logger.d("Leyendo estados de puerto");

      port.readBytesOnListen(8, (value) {
        print("Valor: $value");
        String hex = uint8ListToHex(value);
        print("Valor hex: $hex");
        List<String> listado = hexToList(hex);

        print("Listado hex: ${listado}");

        //Clasificar evento
        if (listado.length == CMD_SELECT_ALL_STATES_SIZE) {
          var placa = hexToDec(listado[1]);

          logger.d("Comando para consultar todo. Placa: $placa");
          callback(placa);
        }
      });
    }
  }

  Future<void> checkConnectedMotherBoards(Callback callback) async {
    if (port.isOpened) {
      CommandBuilder builder = CommandBuilder();
      List<String> comandos = builder.readAllMotherBoards();

      for (int i = 0; i < comandos.length; i++) {
        callback(i + 1);
        logger.d("Enviando commando: ${cleanHex(comandos[i])}");
        port.writeBytesFromUint8List(hexToUint8List(comandos[i]),
            timeout: 1000);
        await Future.delayed(const Duration(seconds: 1));
      }
    } else {
      logger.e("Error al consultar estados de placas");
    }
  }

  void tryOpenDoor(int motherBoard, int door) {
    if (port.isOpened) {
      CommandBuilder builder = CommandBuilder();

      builder.openDoor(motherBoard, door);
    }
  }

  void disconnect() {
    port.close();
  }
}
