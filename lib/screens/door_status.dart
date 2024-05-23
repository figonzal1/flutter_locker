import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locker/utils.dart';
import 'package:logger/logger.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

var logger = Logger();

class DoorStatus extends StatefulWidget {
  const DoorStatus({super.key});

  @override
  State<StatefulWidget> createState() => _DoorStatusState();
}

class _DoorStatusState extends State<DoorStatus> {
  late SerialPort port;

  List<bool?> doorStates = [
    null, //1   false = cerrado | true = abierto
    null, //2
    null, //3
    null, //4
    null, //5
    null, //6
    null, //7
    null, //8
    null, //9
    null, //10
    null, //11
    null //12
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final ports = SerialPort.getAvailablePorts();

    logger.d(ports);

    port = SerialPort("COM3",
        openNow: false, BaudRate: 9600, ByteSize: 8, StopBits: 1);
    openSerialPort();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    port.close();
  }

  void openSerialPort() {
    logger.d("Abriendo puerto");
    port.open();

    if (port.isOpened) {
      logger.d("Puerto abierto correctamente");

      readStatus();
    } else {
      logger.e("Apertura de puerto fallido");
    }
  }

  void openLocker() {
    logger.d("Abrir puerta");

    var result = hexToUint8List("8A 01 01 11 9B");
    logger.d("Comando enviado: ${separateHex("8A 01 01 11 9B")}");

    port.writeBytesFromUint8List(result);
  }

  void readStatus() {
    logger.d("Leyendo estados");
    port.readBytesOnListen(8, (value) {
      String hexDecode = uint8ListToHex(value);
      Map<String, String> list = separateHex(hexDecode);

      logger.d("Comando recibido: $list");

      //Hex to decimal
      var positionDoor = int.parse(list['channel']!, radix: 16);

      logger.i("Codigo puerta: ${list['channel']!} - $positionDoor");

      setState(() {
        //Abierto
        if (list['function'] == "00") {
          doorStates[positionDoor - 1] = true;
        }

        //Cerrado
        if (list['function'] == "11") {
          doorStates[positionDoor - 1] = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Door status"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 5,
              children: List.generate(12, (index) {
                return ListTile(
                  dense: true,
                  title: Text("Puerta ${index + 1}"),
                  subtitle: doorStates[index] != null
                      ? (doorStates[index] == true
                          ? const Text(
                              "Estado: Abierto",
                              style: TextStyle(color: Colors.red, fontSize: 30),
                            )
                          : const Text("Estado: Cerrado",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 30)))
                      : const Text("Estado undefined"),
                );
              }),
            ),
          ),
          MaterialButton(
            onPressed: () {
              openLocker();
            },
            child: Text("Open locker"),
          )
        ],
      ),
    );
  }
}
