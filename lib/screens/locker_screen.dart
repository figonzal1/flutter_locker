import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lockwise_serial_lib/lockwise_serial_lib.dart';
import 'package:lockwise_serial_lib/model/enum_events.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LockerPageStatus extends StatefulWidget {
  const LockerPageStatus({super.key});

  @override
  State<StatefulWidget> createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPageStatus> {
  late LockerPort lockerPort;
  bool isPortConnected = false;

  String placaActual = "";
  List<String> placaDetectada = [];

  @override
  void initState() {
    super.initState();

    logger.d("Init state");

    lockerPort = LockerPort();

    bool result = lockerPort.connectPort(portName: "COM4");

    if (result) {
      //Callback para lockerBox
      lBoxCallback(LockerBoxEvent event) {
        if (event == LockerBoxEvent.AUTO_OPEN) {
          print("Apertura automática");
        } else if (event == LockerBoxEvent.AUTO_OPEN_FAILED) {
          print("Apertura fallida");
        } else if (event == LockerBoxEvent.AUTO_OPEN_CONFIRMED) {
          print("Apertura automática confirmada");
        }

        if (event == LockerBoxEvent.MANUAL_OPEN) {
          print("Apertura manual de puerta detectada");
        } else if (event == LockerBoxEvent.MANUAL_CLOSE) {
          print("Cierre manual detectado");
        }
      }

      mBoardCallback(MBoardEvent event, int idMBoard) {
        if (event == MBoardEvent.CONNECTED) {
          print("Placa $idMBoard conectada");
        }
      }

      //Suscribirse a eventos
      lockerPort.subscribeToLockerBoxEvents(lBoxCallback: lBoxCallback);

      //lockerPort.subscribeToEvents();
      /*myLocker.listenEvents((placa) {
        setState(() {
          placaDetectada.add(placa.toString());
        });
      });*/

      /*myLocker.checkConnectedMotherBoards((placa) {
        setState(() {
          placaActual = placa.toString();
        });
      });*/
    }

    setState(() {
      isPortConnected = result;
    });
  }

  @override
  void dispose() {
    super.dispose();

    logger.d("Dispose ...");

    //myLocker.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locker app"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: isPortConnected
                ? Column(
                    children: [
                      const Text(
                        "Continuar detección",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      ),
                      Text(
                        "ESCANEANDO PLACA: $placaActual",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("ID's Placas detectadas: $placaDetectada")
                    ],
                  )
                : const Center(
                    child: Column(
                    children: [
                      Text(
                        "Error de conexión",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Text(
                        "Revise conexión serial",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  )),
          ),
          MaterialButton(
            onPressed: () async {
              bool sended =
                  lockerPort.openLockerBox(idMBoard: 2, idLockerBox: 1);

              print("Comando enviado: $sended");

              //await Future.delayed(Durations.extralong4);

              //lockerPort.checkMBoardConnectedById(idMBoard: 1);
            },
            child: Text("Apertura de locker P1-C1"),
          )
        ],
      ),
    );
  }
}
