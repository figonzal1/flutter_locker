import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lockwise_serial_lib/locker_box.dart';
import 'package:lockwise_serial_lib/model/enum_events.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LockerPageStatus extends StatefulWidget {
  const LockerPageStatus({super.key});

  @override
  State<StatefulWidget> createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPageStatus> {
  late LockerBox lockerBox;
  bool isPortConnected = false;

  String placaActual = "";
  List<String> placaDetectada = [];

  @override
  void initState() {
    super.initState();

    logger.d("Init state");

    lockerBox = LockerBox();

    bool result = lockerBox.connectPort(portName: "COM4");

    if (result) {
      //Callback para lockerBox (OPERACIONES)
      lBoxOpCallback(LBoxOpEvent opEvent) {
        if (opEvent == LBoxOpEvent.AUTO_OPEN) {
          print("Apertura automática no confirmada");
        } else if (opEvent == LBoxOpEvent.AUTO_OPEN_FAILED) {
          print("Apertura fallida");
        } else if (opEvent == LBoxOpEvent.AUTO_OPEN_CONFIRMED) {
          print("Apertura automática confirmada");
        }

        if (opEvent == LBoxOpEvent.MANUAL_OPEN) {
          print("Apertura manual de puerta detectada");
        } else if (opEvent == LBoxOpEvent.MANUAL_CLOSE) {
          print("Cierre manual detectado");
        }
      }

      //Callback para consultas de estado para locker box's
      lBoxStatusCallback(LBoxStatus statusEvent, int idLBox) {
        if (statusEvent == LBoxStatus.OPEN) {
          print("LockerBOX, id $idLBox -> abierta");
        } else if (statusEvent == LBoxStatus.CLOSE) {
          print("LockerBOX, id $idLBox -> cerrada");
        }
      }

      mBoardCallback(MBoardStatus mBoardStatus, int idMBoard) {
        if (mBoardStatus == MBoardStatus.CONNECTED) {
          print("Placa $idMBoard conectada");
        }
      }

      //Suscribirse a eventos
      lockerBox.subscribeToLockerBoxEvents(
          lBoxOpCallback: lBoxOpCallback,
          lBoxStatusCallback: lBoxStatusCallback);

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
            color: Theme.of(context).colorScheme.inversePrimary,
            onPressed: () async {
              lockerBox.checkLockerBoxStatus(idElectricPanel: "01_01");
            },
            child: const Text("LockerBox status P1-L1"),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.inversePrimary,
            onPressed: () async {
              lockerBox.checkLockerBoxStatus(idElectricPanel: "01_02");
            },
            child: const Text("LockerBox status P1-L2"),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.inversePrimary,
            onPressed: () async {
              bool sended = lockerBox.openLockerBox(idElectricPanel: "01_01");

              print("Comando enviado: $sended");
            },
            child: const Text("Apertura de locker box P1-L1"),
          )
        ],
      ),
    );
  }
}
