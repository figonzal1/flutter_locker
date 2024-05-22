import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_locker/utils.dart';
import 'package:logger/logger.dart';
import 'package:visibility_detector/visibility_detector.dart';

var logger = Logger();

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
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        key: const Key("visible-detector-key"),
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (barcode) {
            var decoded = decodeBarCode(barcode);

            if (!visible) return;

            logger.d("BARDODE: $decoded");

            setState(() {
              _barcode = decoded;
            });
          },
          useKeyDownEvent: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "QR Reader",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _barcode == null ? 'SCAN BARCODE' : 'BARCODE RESULT: $_barcode',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
