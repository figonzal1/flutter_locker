import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locker/locker.dart';
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
  List<String> placaDetectada = [];

  @override
  void initState() {
    super.initState();

    myLocker = Locker();

    bool result = myLocker.tryToConnect();

    if (result) {
      myLocker.listenEvents((placa) {
        setState(() {
          placaDetectada.add(placa.toString());
        });
      });

      myLocker.checkConnectedMotherBoards();
    }

    setState(() {
      isPortConnected = result;
    });
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
          )
        ],
      ),
    );
  }
}
