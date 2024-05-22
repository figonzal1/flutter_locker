import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_locker/second_screen.dart';
import 'package:flutter_locker/utils.dart';
import 'package:logger/logger.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:visibility_detector/visibility_detector.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SerialPort port;
  String? _barcode;
  late bool visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ports = SerialPort.getAvailablePorts();

    logger.d(ports);

    port = SerialPort("COM4",
        openNow: false, BaudRate: 9600, ByteSize: 8, StopBits: 1);
    openPort();
  }

  void openPort() {
    logger.d("Abriendo puerto");
    port.open();

    if (port.isOpened) {
      logger.d("Puerto abierto correctamente");
    } else {
      logger.e("Apertura de puerto fallido");
    }
  }

  void openLocker(String decoded) {
    logger.d("Abrir puerta");

    if (decoded.contains("kucoin")) {
      port.writeBytesFromString(hexToString("8A0101119B"));
    }
  }

  void tryNavigate() {
    if (_barcode!.contains("kucoin")) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MiVista();
      }));
    }
  }

  String hexToString(String hex) {
    String result = '';
    for (int i = 0; i < hex.length; i += 2) {
      String hexChar = hex.substring(i, i + 2);
      int charCode = int.parse(hexChar, radix: 16);
      result += String.fromCharCode(charCode);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Puertos detectados ',
            ),
            MaterialButton(
              onPressed: () {
                openPort();
              },
              child: Text("Abrir puerto"),
            ),
            MaterialButton(
              onPressed: () {
                openLocker("");
              },
              child: Text("Abrir cerradura"),
            ),
            VisibilityDetector(
              onVisibilityChanged: (VisibilityInfo info) {
                visible = info.visibleFraction > 0;
              },
              key: Key("visible-detector-key"),
              child: BarcodeKeyboardListener(
                onBarcodeScanned: (barcode) {
                  var decoded = decodeBarCode(barcode);

                  if (!visible) return;

                  openLocker(decoded);
                  logger.d("BARDODE: $decoded");
                  setState(() {
                    _barcode = decoded;

                    
                    //tryNavigate();
                  });
                },
                useKeyDownEvent: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _barcode == null ? 'SCAN BARCODE' : 'BARCODE: $_barcode',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
