import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locker/model/locker.dart';
import 'package:flutter_locker/utils.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class DoorLedsPage extends StatefulWidget {
  const DoorLedsPage({super.key});

  @override
  State<StatefulWidget> createState() => _DoorLedsPageState();
}

class _DoorLedsPageState extends State<DoorLedsPage> {
  late Locker lockerSerial;
  late Locker ledsSerial;
  bool isPortConnected = false;

  @override
  void initState() {
    super.initState();

    logger.d("Init state");

    lockerSerial = Locker();
    ledsSerial = Locker();

    bool lockerResult = lockerSerial.connectTo("COM4");
    bool ledsResult = ledsSerial.connectTo("COM7");

    //if (result) {
    //myLocker.listenEvents((placa) {});

    /*myLocker.checkConnectedMotherBoards((placa) {
        setState(() {
          placaActual = placa.toString();
        });
      });*/
    //}
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
        title: const Text("Leds Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Leds serial data",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () {
                ledsSerial.sendData("blink 1 on");
                lockerSerial.tryOpenDoor("0101");
              },
              child: const Text("Abrir puerta y encender Blink led 1"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 1 on");
                  },
                  child: const Text("Blink 1 ON"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 2 on");
                  },
                  child: const Text("Blink 2 ON"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 3 on");
                  },
                  child: const Text("Blink 3 ON"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 4 on");
                  },
                  child: const Text("Blink 4 ON"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 1 off");
                  },
                  child: const Text("Blink 1 OFF"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 2 off");
                  },
                  child: const Text("Blink 2 OFF"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 3 off");
                  },
                  child: const Text("Blink 3 OFF"),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () {
                    ledsSerial.sendData("blink 4 off");
                  },
                  child: const Text("Blink 4 OFF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
