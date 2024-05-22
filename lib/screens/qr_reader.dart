import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:visibility_detector/visibility_detector.dart';

class QrReader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  String? _barcode;
  late bool visible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Reader"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: VisibilityDetector(
          onVisibilityChanged: ,
          key: Key("visible-detector-key"),
          child: BarcodeKeyboardListener(
              child: child, onBarcodeScanned: onBarcodeScanned),
        ),
      ),
    );
  }
}
