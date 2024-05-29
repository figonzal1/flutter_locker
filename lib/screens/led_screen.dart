import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lockwise_serial_lib/locker_leds.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LedsPage extends StatefulWidget {
  const LedsPage({super.key});

  @override
  State<StatefulWidget> createState() => _LedsPageState();
}

class _LedsPageState extends State<LedsPage> {
  late LockerLeds lockerLeds;

  bool isPortConnected = false;

  @override
  void initState() {
    super.initState();

    logger.d("Init state");

    lockerLeds = LockerLeds();

    bool result = lockerLeds.connectPort(portName: "COM10");

    if (result) {}

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
                ? const Column(
                    children: [
                      Text(
                        "Panel de leds",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      ),
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
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.turnOn(idLed: 1, color: "green");
                },
                child: const Text("Encender led 1 verde"),
              ),
              const SizedBox(
                width: 20,
              ),
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.turnOff(idLed: 1);
                },
                child: const Text("Apagar led 1"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.turnOn(idLed: 2, color: "red");
                },
                child: const Text("Encender led 2 rojo"),
              ),
              const SizedBox(
                width: 20,
              ),
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.turnOff(idLed: 2);
                },
                child: const Text("Apagar led 2"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.blink(1);
                },
                child: const Text("Blink led 1"),
              ),
              const SizedBox(
                width: 20,
              ),
              MaterialButton(
                color: Theme.of(context).colorScheme.inversePrimary,
                onPressed: () async {
                  lockerLeds.blink(2);
                },
                child: const Text("Blink led 2"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
