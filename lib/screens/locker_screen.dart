import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locker/model/locker.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LockerPageStatus extends StatefulWidget {
  const LockerPageStatus({super.key});

  @override
  State<StatefulWidget> createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPageStatus> {
  late Locker myLocker;
  bool isPortConnected = false;

  String placaActual = "";
  List<String> placaDetectada = [];

  @override
  void initState() {
    super.initState();

    logger.d("Init state");

    myLocker = Locker();

    bool result = myLocker.tryToConnect();

    if (result) {
      myLocker.listenEvents((placa) {
        setState(() {
          placaDetectada.add(placa.toString());
        });
      });

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
              myLocker.checkConnectedMotherBoardById(idMb: 1);

              //Delay requerido para que placa procese el siguiente comando
              await Future.delayed(const Duration(seconds: 1));

              //Abrir puerta - ID placa + Id locker box
              myLocker.tryOpenDoor("0101");
            },
            child: Text("Apertura de locker P1-C1"),
          )
        ],
      ),
    );
  }
}
